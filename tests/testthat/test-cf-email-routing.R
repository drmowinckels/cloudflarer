describe("cf_get_email_routing_settings()", {
  it("returns the routing settings", {
    local_mock_auth()
    vcr::use_cassette("email_routing_settings", {
      res <- cf_get_email_routing_settings("zone-1")
    })
    expect_true(res$enabled)
    expect_equal(res$status, "ready")
    expect_equal(res$name, "example.com")
  })
})

describe("cf_list_email_routing_rules()", {
  it("returns a data.frame of routing rules from a cassette", {
    local_mock_auth()
    vcr::use_cassette("email_routing_rules_list", {
      df <- cf_list_email_routing_rules("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true("matchers" %in% names(df))
    expect_type(df$matchers, "list")
    expect_equal(df$name, c("Send hello@ to gmail", "Catch-all to backup"))
  })

  it("forwards enabled_only as a query parameter", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_email_routing_rules("zone-1", enabled_only = TRUE)
    expect_match(cap$req$url, "zones/zone-1/email/routing/rules")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$enabled, "true")
  })

  it("rejects a non-logical enabled_only with a named message", {
    expect_error(
      cf_list_email_routing_rules("zone-1", enabled_only = "yes"),
      "enabled_only"
    )
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("email_routing_rules_list", {
      res <- cf_list_email_routing_rules("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "rule-1")
  })
})

describe("cf_list_email_routing_addresses()", {
  it("returns a data.frame of addresses from a cassette", {
    local_mock_auth()
    vcr::use_cassette("email_routing_addresses_list", {
      df <- cf_list_email_routing_addresses("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$email, c("me@gmail.com", "backup@gmail.com"))
  })

  it("forwards verified_only as a query parameter", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_email_routing_addresses("acc-1", verified_only = TRUE)
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$verified, "true")
  })

  it("rejects a non-logical verified_only with a named message", {
    expect_error(
      cf_list_email_routing_addresses("acc-1", verified_only = NA),
      "verified_only"
    )
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("email_routing_addresses_list", {
      res <- cf_list_email_routing_addresses("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$email, "me@gmail.com")
  })
})
