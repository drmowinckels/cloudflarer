describe("cf_list_rulesets()", {
  it("returns a data.frame of rulesets from a cassette", {
    local_mock_auth()
    vcr::use_cassette("rulesets_zone_list", {
      df <- cf_list_rulesets("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true(all(c("id", "name", "phase") %in% names(df)))
    expect_equal(df$id, c("rs-1", "rs-2"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("rulesets_zone_list", {
      res <- cf_list_rulesets("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "rs-1")
  })
})

describe("cf_get_ruleset()", {
  it("returns a ruleset with its rules", {
    local_mock_auth()
    vcr::use_cassette("ruleset_zone_get", {
      rs <- cf_get_ruleset("zone-1", "rs-1")
    })
    expect_equal(rs$id, "rs-1")
    expect_length(rs$rules, 1)
    expect_equal(rs$rules[[1]]$action, "block")
  })
})

describe("cf_list_account_rulesets()", {
  it("returns a data.frame of managed rulesets from a cassette", {
    local_mock_auth()
    vcr::use_cassette("rulesets_account_list", {
      df <- cf_list_account_rulesets("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 1L)
    expect_equal(df$kind, "managed")
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("rulesets_account_list", {
      res <- cf_list_account_rulesets("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "managed-1")
  })
})

describe("cf_get_account_ruleset()", {
  it("returns an account ruleset with its rules", {
    local_mock_auth()
    vcr::use_cassette("ruleset_account_get", {
      rs <- cf_get_account_ruleset("acc-1", "managed-1")
    })
    expect_equal(rs$id, "managed-1")
    expect_length(rs$rules, 1)
  })
})
