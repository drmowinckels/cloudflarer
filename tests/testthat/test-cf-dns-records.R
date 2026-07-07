describe("cf_list_dns_records()", {
  it("targets the dns_records endpoint of the zone with filters", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_dns_records("zone-1", type = "A", name = "www.example.com")
    expect_match(cap$req$url, "zones/zone-1/dns_records")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$type, "A")
    expect_equal(query$name, "www.example.com")
  })
})

describe("cf_list_dns_records() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_collect = function(req, ...) list(list(id = "r-1", type = "A"))
    )
    local_mock_auth()
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

  it("builds a POST request carrying the body", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"rec-x"}}'
    )
    local_mock_auth()
    res <- cf_create_dns_record(
      "zone-1",
      type = "TXT",
      name = "_dmarc.example.com",
      content = "v=DMARC1; p=none;"
    )
    expect_match(cap$req$url, "zones/zone-1/dns_records")
    expect_equal(cap$req$method, "POST")
    expect_equal(cap$req$body$data$type, "TXT")
    expect_equal(cap$req$body$data$content, "v=DMARC1; p=none;")
    expect_equal(res$id, "rec-x")
  })

  it("drops NULL optional fields from the body", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_create_dns_record("zone-1", "A", "x", "192.0.2.1")
    body <- cap$req$body$data
    expect_false("proxied" %in% names(body))
    expect_false("priority" %in% names(body))
    expect_false("comment" %in% names(body))
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
    cap <- local_captured_request()
    local_mock_auth()
    cf_update_dns_record("zone-1", "rec-1", content = "5.6.7.8")
    expect_equal(cap$req$method, "PATCH")
    expect_equal(cap$req$body$data, list(content = "5.6.7.8"))
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
