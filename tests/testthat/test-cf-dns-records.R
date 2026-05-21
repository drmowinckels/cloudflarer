describe("cf_list_dns_records()", {
  it("targets the dns_records endpoint of the zone", {
    captured <- NULL
    local_mocked_bindings(
      cf_request_collect = function(endpoint, query, ...) {
        captured <<- list(endpoint = endpoint, query = query)
        list()
      }
    )
    cf_list_dns_records("zone-1", type = "A", name = "www.example.com")
    expect_equal(captured$endpoint, "zones/zone-1/dns_records")
    expect_equal(captured$query$type, "A")
    expect_equal(captured$query$name, "www.example.com")
  })
})

describe("cf_list_dns_records() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_request_collect = function(...) list(list(id = "r-1", type = "A"))
    )
    res <- cf_list_dns_records("zone-1", as_df = FALSE)
    expect_type(res, "list")
    expect_equal(res[[1]]$type, "A")
  })
})

describe("cf_get_dns_record()", {
  it("returns the record", {
    local_mock_auth()
    vcr::use_cassette("dns_record_get", {
      rec <- cf_get_dns_record("zone-1", "rec-1")
    })
    expect_equal(rec$id, "rec-1")
    expect_equal(rec$type, "A")
    expect_equal(rec$content, "192.0.2.1")
  })
})

describe("cf_create_dns_record()", {
  it("POSTs the new record and returns it", {
    local_mock_auth()
    vcr::use_cassette("dns_record_create", {
      rec <- cf_create_dns_record(
        "zone-1",
        type = "A",
        name = "blog.example.com",
        content = "192.0.2.5",
        ttl = 300
      )
    })
    expect_equal(rec$id, "rec-new")
    expect_equal(rec$name, "blog.example.com")
  })

  it("forwards the body to cf_request", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- list(endpoint = endpoint, method = method, body = body)
        list(id = "rec-x")
      }
    )
    cf_create_dns_record(
      "zone-1",
      type = "TXT",
      name = "_dmarc.example.com",
      content = "v=DMARC1; p=none;"
    )
    expect_equal(captured$endpoint, "zones/zone-1/dns_records")
    expect_equal(captured$method, "POST")
    expect_equal(captured$body$type, "TXT")
    expect_equal(captured$body$content, "v=DMARC1; p=none;")
  })

  it("drops NULL optional fields from the body", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- body
        list()
      }
    )
    cf_create_dns_record("zone-1", "A", "x", "1.2.3.4")
    expect_false("proxied" %in% names(captured))
    expect_false("priority" %in% names(captured))
    expect_false("comment" %in% names(captured))
  })
})

describe("cf_update_dns_record()", {
  it("PATCHes the record", {
    local_mock_auth()
    vcr::use_cassette("dns_record_update", {
      rec <- cf_update_dns_record("zone-1", "rec-1", content = "192.0.2.99")
    })
    expect_equal(rec$content, "192.0.2.99")
  })

  it("only sends supplied fields", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- list(method = method, body = body)
        list()
      }
    )
    cf_update_dns_record("zone-1", "rec-1", content = "5.6.7.8")
    expect_equal(captured$method, "PATCH")
    expect_equal(captured$body, list(content = "5.6.7.8"))
  })
})

describe("cf_delete_dns_record()", {
  it("DELETEs the record", {
    local_mock_auth()
    vcr::use_cassette("dns_record_delete", {
      res <- cf_delete_dns_record("zone-1", "rec-1")
    })
    expect_equal(res$id, "rec-1")
  })
})
