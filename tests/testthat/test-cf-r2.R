describe("cf_list_r2_buckets()", {
  it("returns a data.frame of buckets from a cassette", {
    local_mock_auth()
    vcr::use_cassette("r2_buckets_list", {
      df <- cf_list_r2_buckets("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("my-assets", "backups-cold"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("r2_buckets_list", {
      res <- cf_list_r2_buckets("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$name, "my-assets")
  })

  it("returns an empty data.frame when there are no buckets", {
    local_mocked_bindings(cf_request = function(...) list(buckets = list()))
    df <- cf_list_r2_buckets("acc-1")
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 0L)
  })
})

describe("cf_get_r2_bucket()", {
  it("returns a single bucket", {
    local_mock_auth()
    vcr::use_cassette("r2_bucket_get", {
      b <- cf_get_r2_bucket("acc-1", "my-assets")
    })
    expect_equal(b$name, "my-assets")
    expect_equal(b$storage_class, "Standard")
  })
})
