describe("cf_get_zone_settings()", {
  it("returns a data.frame of settings from a cassette", {
    local_mock_auth()
    vcr::use_cassette("zone_settings_all", {
      df <- cf_get_zone_settings("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 3L)
    expect_true(all(c("id", "value", "editable") %in% names(df)))
    expect_true("ssl" %in% df$id)
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("zone_settings_all", {
      res <- cf_get_zone_settings("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "ssl")
  })
})

describe("cf_get_zone_setting()", {
  it("returns a single setting", {
    local_mock_auth()
    vcr::use_cassette("zone_setting_ssl", {
      res <- cf_get_zone_setting("zone-1", "ssl")
    })
    expect_equal(res$id, "ssl")
    expect_equal(res$value, "flexible")
  })
})
