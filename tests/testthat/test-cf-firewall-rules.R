describe("cf_list_firewall_rules()", {
  it("returns a data.frame of firewall rules from a cassette", {
    local_mock_auth()
    vcr::use_cassette("firewall_rules_list", {
      df <- cf_list_firewall_rules("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true("action" %in% names(df))
    expect_equal(df$action, c("block", "challenge"))
    expect_type(df$filter, "list")
    expect_equal(df$filter[[1]]$expression, "(cf.client.bot)")
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("firewall_rules_list", {
      res <- cf_list_firewall_rules("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "fw-1")
  })
})
