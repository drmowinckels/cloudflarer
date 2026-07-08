describe("cf_list_healthchecks()", {
  it("returns a data.frame of healthchecks", {
    local_mock_auth()
    vcr::use_cassette("healthchecks_list", {
      df <- cf_list_healthchecks("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("api-prod", "api-staging"))
    expect_equal(df$type, c("HTTPS", "HTTP"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("healthchecks_list", {
      res <- cf_list_healthchecks("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "hc-1")
  })
})

describe("cf_get_healthcheck()", {
  it("returns a single healthcheck", {
    local_mock_auth()
    vcr::use_cassette("healthcheck_get", {
      hc <- cf_get_healthcheck("zone-1", "hc-1")
    })
    expect_equal(hc$id, "hc-1")
    expect_equal(hc$name, "api-prod")
    expect_equal(hc$http_config$path, "/health")
  })
})

describe("cf_create_healthcheck()", {
  it("posts a healthcheck and returns the created record", {
    local_mock_auth()
    vcr::use_cassette("healthcheck_create", {
      hc <- cf_create_healthcheck(
        "zone-1",
        name = "api-prod",
        address = "api.example.com",
        type = "HTTPS",
        http_config = list(path = "/health", expected_codes = "200")
      )
    })
    expect_equal(hc$id, "hc-1")
    expect_equal(hc$address, "api.example.com")
  })
})

describe("cf_update_healthcheck()", {
  it("patches a healthcheck", {
    local_mock_auth()
    vcr::use_cassette("healthcheck_update", {
      hc <- cf_update_healthcheck("zone-1", "hc-1", suspended = TRUE)
    })
    expect_true(hc$suspended)
  })
})

describe("cf_delete_healthcheck()", {
  it("deletes a healthcheck", {
    local_mock_auth()
    vcr::use_cassette("healthcheck_delete", {
      out <- cf_delete_healthcheck("zone-1", "hc-1")
    })
    expect_equal(out$id, "hc-1")
  })
})
