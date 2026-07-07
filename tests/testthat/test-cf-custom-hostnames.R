describe("cf_list_custom_hostnames()", {
  it("returns a data.frame of custom hostnames", {
    local_mock_auth()
    vcr::use_cassette("custom_hostnames_list", {
      df <- cf_list_custom_hostnames("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$hostname, c("shop.customer.com", "blog.customer.com"))
    expect_equal(df$status, c("active", "pending"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("custom_hostnames_list", {
      res <- cf_list_custom_hostnames("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "ch-1")
  })
})

describe("cf_get_custom_hostname()", {
  it("returns a single custom hostname", {
    local_mock_auth()
    vcr::use_cassette("custom_hostname_get", {
      ch <- cf_get_custom_hostname("zone-1", "ch-1")
    })
    expect_equal(ch$id, "ch-1")
    expect_equal(ch$hostname, "shop.customer.com")
    expect_equal(ch$ssl$method, "txt")
  })
})

describe("cf_create_custom_hostname()", {
  it("posts a custom hostname and returns the created record", {
    local_mock_auth()
    vcr::use_cassette("custom_hostname_create", {
      ch <- cf_create_custom_hostname(
        "zone-1",
        hostname = "shop.customer.com",
        ssl_method = "txt"
      )
    })
    expect_equal(ch$id, "ch-1")
    expect_equal(ch$ssl$method, "txt")
  })
})

describe("cf_delete_custom_hostname()", {
  it("deletes a custom hostname", {
    local_mock_auth()
    vcr::use_cassette("custom_hostname_delete", {
      out <- cf_delete_custom_hostname("zone-1", "ch-1")
    })
    expect_equal(out$id, "ch-1")
  })
})
