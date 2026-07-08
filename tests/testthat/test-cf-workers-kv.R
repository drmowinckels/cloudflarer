describe("cf_list_kv_namespaces()", {
  it("returns a data.frame of KV namespaces from a cassette", {
    local_mock_auth()
    vcr::use_cassette("kv_namespaces_list", {
      df <- cf_list_kv_namespaces("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$title, c("sessions", "feature-flags"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("kv_namespaces_list", {
      res <- cf_list_kv_namespaces("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "ns-1")
  })
})

describe("cf_get_kv_namespace()", {
  it("returns a single namespace", {
    local_mock_auth()
    vcr::use_cassette("kv_namespace_get", {
      ns <- cf_get_kv_namespace("acc-1", "ns-1")
    })
    expect_equal(ns$id, "ns-1")
    expect_equal(ns$title, "sessions")
  })
})

describe("cf_create_kv_namespace()", {
  it("POSTs the title and returns the created namespace", {
    local_mock_auth()
    vcr::use_cassette("kv_namespace_create", {
      ns <- cf_create_kv_namespace("acc-1", "sessions")
    })
    expect_equal(ns$id, "ns-new")
    expect_equal(ns$title, "sessions")
  })

  it("sends the title in the request body", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"ns-x"}}'
    )
    local_mock_auth()
    cf_create_kv_namespace("acc-1", "sessions")
    expect_equal(cap$req$method, "POST")
    expect_equal(cap$req$body$data, list(title = "sessions"))
  })
})

describe("cf_rename_kv_namespace()", {
  it("PUTs the new title and returns the renamed namespace", {
    local_mock_auth()
    vcr::use_cassette("kv_namespace_rename", {
      ns <- cf_rename_kv_namespace("acc-1", "ns-1", "sessions-v2")
    })
    expect_equal(ns$id, "ns-1")
    expect_equal(ns$title, "sessions-v2")
  })
})

describe("cf_delete_kv_namespace()", {
  it("DELETEs the namespace", {
    local_mock_auth()
    vcr::use_cassette("kv_namespace_delete", {
      res <- cf_delete_kv_namespace("acc-1", "ns-1")
    })
    expect_null(res)
  })
})

describe("cf_list_kv_keys()", {
  it("returns a data.frame of keys from a cassette", {
    local_mock_auth()
    vcr::use_cassette("kv_keys_list", {
      df <- cf_list_kv_keys("acc-1", "ns-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(df$name, c("greeting", "farewell"))
  })

  it("walks every page until the cursor is exhausted", {
    pages <- list(
      list(
        result = list(list(name = "a"), list(name = "b")),
        result_info = list(cursor = "next-cursor")
      ),
      list(
        result = list(list(name = "c")),
        result_info = list(cursor = "")
      )
    )
    state <- new.env(parent = emptyenv())
    state$n <- 0L
    local_mocked_bindings(
      req_perform = function(req, ...) {
        state$n <- state$n + 1L
        structure(list(page = state$n), class = "httr2_response")
      },
      .package = "httr2"
    )
    local_mocked_bindings(cf_resp_envelope = function(resp) pages[[resp$page]])
    local_mock_auth()
    out <- cf_list_kv_keys("acc-1", "ns-1", as_df = FALSE)
    expect_length(out, 3)
    expect_equal(out[[3]]$name, "c")
  })

  it("respects max_pages", {
    local_mocked_bindings(
      req_perform = function(req, ...) {
        structure(list(), class = "httr2_response")
      },
      .package = "httr2"
    )
    local_mocked_bindings(
      cf_resp_envelope = function(resp) {
        list(
          result = list(list(name = "a")),
          result_info = list(cursor = "still-more")
        )
      }
    )
    local_mock_auth()
    out <- cf_list_kv_keys("acc-1", "ns-1", as_df = FALSE, max_pages = 2)
    expect_length(out, 2)
  })
})

describe("cf_get_kv_value()", {
  it("returns the raw stored value as text", {
    local_mock_auth()
    vcr::use_cassette("kv_value_get", {
      val <- cf_get_kv_value("acc-1", "ns-1", "greeting")
    })
    expect_equal(val, "hello world")
  })

  it("aborts with the parsed error envelope when the key is missing", {
    local_mock_auth()
    expect_error(
      vcr::use_cassette("kv_value_get_missing", {
        cf_get_kv_value("acc-1", "ns-1", "greeting")
      }),
      class = "cloudflarer_error"
    )
  })

  it("rejects a key_name that would inject extra path segments", {
    local_mock_auth()
    expect_error(
      cf_get_kv_value("acc-1", "ns-1", "../../accounts/other/storage"),
      "must not contain"
    )
  })
})

describe("cf_put_kv_value()", {
  it("PUTs the raw value and returns TRUE invisibly", {
    local_mock_auth()
    vcr::use_cassette("kv_value_put", {
      res <- cf_put_kv_value("acc-1", "ns-1", "greeting", "hello world")
    })
    expect_true(res)
  })

  it("sends the value as a raw body and expiration as query params", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_put_kv_value(
      "acc-1",
      "ns-1",
      "greeting",
      "hello world",
      expiration_ttl = 3600
    )
    expect_equal(cap$req$method, "PUT")
    expect_equal(cap$req$body$data, "hello world")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$expiration_ttl, "3600")
  })

  it("rejects a key_name that would inject extra path segments", {
    local_mock_auth()
    expect_error(
      cf_put_kv_value("acc-1", "ns-1", "a/../b", "hello world"),
      "must not contain"
    )
  })
})

describe("cf_delete_kv_value()", {
  it("DELETEs the key", {
    local_mock_auth()
    vcr::use_cassette("kv_value_delete", {
      res <- cf_delete_kv_value("acc-1", "ns-1", "greeting")
    })
    expect_null(res)
  })

  it("rejects a key_name that would inject extra path segments", {
    local_mock_auth()
    expect_error(
      cf_delete_kv_value("acc-1", "ns-1", "a/../b"),
      "must not contain"
    )
  })
})

describe("cf_put_kv_values()", {
  it("PUTs the bulk array and returns the summary", {
    local_mock_auth()
    vcr::use_cassette("kv_values_put_bulk", {
      res <- cf_put_kv_values(
        "acc-1",
        "ns-1",
        list(
          list(key = "greeting", value = "hello"),
          list(key = "farewell", value = "bye")
        )
      )
    })
    expect_equal(res$successful_key_count, 2)
  })

  it("rejects an empty values list", {
    local_mock_auth()
    expect_error(
      cf_put_kv_values("acc-1", "ns-1", list()),
      "non-empty list"
    )
  })
})

describe("cf_delete_kv_values()", {
  it("DELETEs the bulk array and returns the summary", {
    local_mock_auth()
    vcr::use_cassette("kv_values_delete_bulk", {
      res <- cf_delete_kv_values("acc-1", "ns-1", c("greeting", "farewell"))
    })
    expect_equal(res$successful_key_count, 2)
  })

  it("rejects an empty keys vector", {
    local_mock_auth()
    expect_error(
      cf_delete_kv_values("acc-1", "ns-1", character(0)),
      "non-empty character vector"
    )
  })
})
