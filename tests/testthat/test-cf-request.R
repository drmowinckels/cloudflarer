describe("cf_request()", {
  it("builds an authenticated request with the endpoint path", {
    local_mock_auth()
    req <- cf_request(c("zones", "abc"))
    expect_s3_class(req, "httr2_request")
    expect_match(req$url, "zones/abc$")
    headers <- httr2::req_dry_run(
      req,
      quiet = TRUE,
      redact_headers = FALSE
    )$headers
    expect_equal(headers$authorization, paste("Bearer", mock_token))
  })

  it("accepts a slash-joined endpoint string", {
    local_mock_auth()
    req <- cf_request("zones/abc/dns_records")
    expect_match(req$url, "zones/abc/dns_records$")
  })
})

describe("cf_resp()", {
  it("returns the result element from a successful envelope", {
    local_mock_auth()
    vcr::use_cassette("token_verify_ok", {
      res <- cf_request("user/tokens/verify") |>
        httr2::req_perform() |>
        cf_resp()
    })
    expect_type(res, "list")
    expect_true("status" %in% names(res))
  })

  it("raises a classed error when success is FALSE", {
    local_mock_auth()
    vcr::use_cassette("zones_unauthorised", {
      expect_error(
        cf_request("zones") |> httr2::req_perform() |> cf_resp(),
        class = "cloudflarer_error"
      )
    })
  })
})

request_headers <- function(req) {
  req_dry_run(req, quiet = TRUE, redact_headers = FALSE)$headers
}

describe("cf_req_auth()", {
  it("attaches a bearer token when one is supplied explicitly", {
    headers <- request("https://example.com") |>
      cf_req_auth(token = "abc") |>
      request_headers()
    expect_equal(headers$authorization, "Bearer abc")
  })

  it("attaches X-Auth headers when email and key are supplied explicitly", {
    headers <- request("https://example.com") |>
      cf_req_auth(email = "me@example.com", api_key = "secret") |>
      request_headers()
    expect_equal(headers$`x-auth-email`, "me@example.com")
    expect_equal(headers$`x-auth-key`, "secret")
  })

  it("redacts the API key and email from the request's printed form", {
    req <- request("https://example.com") |>
      cf_req_auth(email = "me@example.com", api_key = "supersecret-key")
    printed <- paste(utils::capture.output(print(req)), collapse = "\n")
    expect_false(grepl("supersecret-key", printed, fixed = TRUE))
    expect_false(grepl("me@example.com", printed, fixed = TRUE))
    expect_match(printed, "REDACTED")
  })

  it("redacts the bearer token from the request's printed form", {
    req <- request("https://example.com") |>
      cf_req_auth(token = "supersecret-token")
    printed <- paste(utils::capture.output(print(req)), collapse = "\n")
    expect_false(grepl("supersecret-token", printed, fixed = TRUE))
    expect_match(printed, "REDACTED")
  })

  it("picks token mode from env vars when no explicit args are passed", {
    local_mock_auth()
    headers <- request("https://example.com") |>
      cf_req_auth() |>
      request_headers()
    expect_equal(headers$authorization, paste("Bearer", mock_token))
  })

  it("picks key mode from env vars when token is not set", {
    local_mock_key_auth()
    headers <- request("https://example.com") |>
      cf_req_auth() |>
      request_headers()
    expect_equal(headers$`x-auth-email`, mock_email)
    expect_equal(headers$`x-auth-key`, mock_api_key)
  })

  it("aborts when no credentials are configured", {
    local_no_auth()
    req <- request("https://example.com")
    expect_error(cf_req_auth(req), "No Cloudflare credentials")
  })

  it("prefers an explicit token over env-var key credentials", {
    local_mock_key_auth()
    headers <- request("https://example.com") |>
      cf_req_auth(token = "override") |>
      request_headers()
    expect_equal(headers$authorization, "Bearer override")
    expect_null(headers$`x-auth-email`)
  })
})

describe("cf_resp_envelope()", {
  it("returns the parsed envelope on success", {
    fake_resp <- response(
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw('{"success":true,"result":{"id":"x"}}')
    )
    out <- cf_resp_envelope(fake_resp)
    expect_true(out$success)
    expect_equal(out$result$id, "x")
  })

  it("raises a cloudflarer_error when success is FALSE", {
    fake_resp <- response(
      status_code = 400,
      headers = list(`content-type` = "application/json"),
      body = charToRaw(
        '{"success":false,"errors":[{"code":1,"message":"bad"}],"messages":[]}'
      )
    )
    expect_error(cf_resp_envelope(fake_resp), class = "cloudflarer_error")
  })

  it("raises a cloudflarer_error on non-JSON body", {
    fake_resp <- response(
      status_code = 500,
      headers = list(`content-type` = "text/html"),
      body = charToRaw("<html>broken</html>")
    )
    expect_error(cf_resp_envelope(fake_resp), class = "cloudflarer_error")
  })

  it("returns an empty success envelope when the body is empty and status is 2xx", {
    fake_resp <- response(
      status_code = 204,
      headers = list(),
      body = raw(0)
    )
    out <- cf_resp_envelope(fake_resp)
    expect_true(out$success)
    expect_null(out$result)
  })

  it("raises a cloudflarer_error on an empty body with a 4xx status", {
    fake_resp <- response(
      status_code = 500,
      headers = list(),
      body = raw(0)
    )
    expect_error(cf_resp_envelope(fake_resp), class = "cloudflarer_error")
  })
})

describe("request pipeline", {
  it("injects query parameters into the request", {
    local_mock_auth()
    vcr::use_cassette("accounts_one_page", {
      out <- cf_request("accounts") |> cf_collect(per_page = 2)
    })
    expect_length(out, 2)
    expect_equal(out[[1]]$id, "acc-1")
  })

  it("sends a JSON body on POST requests", {
    local_mock_auth()
    vcr::use_cassette("dns_create_error", {
      expect_error(
        cf_request("zones/zone-1/dns_records") |>
          httr2::req_method("POST") |>
          httr2::req_body_json(list(
            type = "A",
            name = "www.example.com",
            content = "192.0.2.1"
          )) |>
          httr2::req_perform() |>
          cf_resp(),
        class = "cloudflarer_error"
      )
    })
  })
})

describe("format_cf_errors()", {
  it("returns a placeholder message when the errors list is empty", {
    expect_equal(format_cf_errors(list()), "No error details provided.")
    expect_equal(format_cf_errors(NULL), "No error details provided.")
  })
})

describe("cf_collect()", {
  it("walks every page until total_pages is reached", {
    pages <- list(
      list(
        result = list(list(id = 1), list(id = 2)),
        result_info = list(page = 1, total_pages = 3)
      ),
      list(
        result = list(list(id = 3), list(id = 4)),
        result_info = list(page = 2, total_pages = 3)
      ),
      list(
        result = list(list(id = 5)),
        result_info = list(page = 3, total_pages = 3)
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
    out <- cf_request("zones") |> cf_collect(per_page = 2)
    expect_length(out, 5)
    expect_equal(out[[5]]$id, 5)
  })

  it("tolerates a missing result field on an otherwise-OK page", {
    local_mocked_bindings(
      req_perform = function(req, ...) {
        structure(list(), class = "httr2_response")
      },
      .package = "httr2"
    )
    local_mocked_bindings(
      cf_resp_envelope = function(resp) {
        list(result_info = list(page = 1, total_pages = 1))
      }
    )
    local_mock_auth()
    out <- cf_request("zones") |> cf_collect()
    expect_equal(out, list())
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
          result = list(list(id = 1)),
          result_info = list(page = 1, total_pages = 99)
        )
      }
    )
    local_mock_auth()
    out <- cf_request("zones") |> cf_collect(per_page = 1, max_pages = 2)
    expect_length(out, 2)
  })
})

describe("cf_req_path()", {
  it("appends every path segment", {
    req <- request("https://example.com") |>
      cf_req_path("a/b/c")
    expect_equal(req$url, "https://example.com/a/b/c")
  })

  it("accepts a character vector of segments", {
    req <- request("https://example.com") |>
      cf_req_path(c("zones", "zone-1", "dns_records"))
    expect_equal(req$url, "https://example.com/zones/zone-1/dns_records")
  })

  it("is a no-op for an empty endpoint", {
    req <- request("https://example.com/")
    expect_equal(cf_req_path(req, "")$url, "https://example.com/")
  })

  it("drops empty segments from leading or trailing slashes", {
    req <- request("https://example.com") |>
      cf_req_path("/a//b/")
    expect_equal(req$url, "https://example.com/a/b")
  })
})

describe("drop_nulls()", {
  it("removes NULL entries from a list", {
    expect_equal(drop_nulls(list(a = 1, b = NULL, c = 3)), list(a = 1, c = 3))
  })

  it("returns the input unchanged when empty", {
    expect_equal(drop_nulls(list()), list())
    expect_null(drop_nulls(NULL))
  })
})
