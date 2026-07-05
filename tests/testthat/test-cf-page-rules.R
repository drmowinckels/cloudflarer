describe("cf_list_page_rules()", {
  it("returns a data.frame of rules from a cassette", {
    local_mock_auth()
    vcr::use_cassette("page_rules_list", {
      df <- cf_list_page_rules("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true("status" %in% names(df))
    expect_true("targets" %in% names(df))
    expect_type(df$targets, "list")
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("page_rules_list", {
      res <- cf_list_page_rules("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "rule-1")
  })

  it("forwards optional query parameters", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_page_rules(
      "zone-1",
      status = "active",
      order = "priority",
      direction = "desc"
    )
    expect_match(cap$req$url, "zones/zone-1/pagerules")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$status, "active")
    expect_equal(query$order, "priority")
    expect_equal(query$direction, "desc")
  })
})

describe("cf_get_page_rule()", {
  it("returns a single rule", {
    local_mock_auth()
    vcr::use_cassette("page_rule_get", {
      rule <- cf_get_page_rule("zone-1", "rule-1")
    })
    expect_equal(rule$id, "rule-1")
    expect_equal(rule$status, "active")
    expect_length(rule$actions, 1)
  })
})

describe("cf_create_page_rule()", {
  it("POSTs the new rule and returns it", {
    local_mock_auth()
    vcr::use_cassette("page_rule_create", {
      rule <- cf_create_page_rule(
        "zone-1",
        targets = list(cf_page_rule_target("*example.com/blog/*")),
        actions = list(cf_page_rule_action("cache_level", "cache_everything"))
      )
    })
    expect_equal(rule$id, "rule-new")
    expect_equal(rule$status, "active")
  })

  it("forwards the body to the request", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"rule-x"}}'
    )
    local_mock_auth()
    cf_create_page_rule(
      "zone-1",
      targets = list(cf_page_rule_target("*example.com/blog/*")),
      actions = list(cf_page_rule_action("cache_level", "cache_everything")),
      priority = 5,
      status = "disabled"
    )
    expect_match(cap$req$url, "zones/zone-1/pagerules$")
    expect_equal(cap$req$method, "POST")
    body <- cap$req$body$data
    expect_equal(body$priority, 5)
    expect_equal(body$status, "disabled")
    expect_equal(body$targets[[1]]$target, "url")
    expect_equal(body$actions[[1]]$id, "cache_level")
  })
})

describe("cf_update_page_rule()", {
  it("PATCHes the rule", {
    local_mock_auth()
    vcr::use_cassette("page_rule_update", {
      res <- cf_update_page_rule("zone-1", "rule-1", status = "disabled")
    })
    expect_equal(res$status, "disabled")
  })

  it("sends only supplied fields", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_update_page_rule("zone-1", "rule-1", priority = 9)
    expect_equal(cap$req$method, "PATCH")
    expect_equal(cap$req$body$data, list(priority = 9))
  })
})

describe("cf_delete_page_rule()", {
  it("DELETEs the rule", {
    local_mock_auth()
    vcr::use_cassette("page_rule_delete", {
      res <- cf_delete_page_rule("zone-1", "rule-1")
    })
    expect_equal(res$id, "rule-1")
  })
})

describe("cf_page_rule_target()", {
  it("builds a URL-match target", {
    out <- cf_page_rule_target("*example.com/blog/*")
    expect_equal(out$target, "url")
    expect_equal(out$constraint$operator, "matches")
    expect_equal(out$constraint$value, "*example.com/blog/*")
  })
})

describe("cf_page_rule_action()", {
  it("builds a simple action", {
    out <- cf_page_rule_action("cache_level", "cache_everything")
    expect_equal(out, list(id = "cache_level", value = "cache_everything"))
  })

  it("preserves nested values", {
    out <- cf_page_rule_action(
      "forwarding_url",
      list(url = "https://example.com/$1", status_code = 301L)
    )
    expect_equal(out$id, "forwarding_url")
    expect_equal(out$value$status_code, 301L)
  })
})
