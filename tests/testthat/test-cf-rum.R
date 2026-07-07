describe("cf_list_rum_sites()", {
  it("calls the RUM site_info/list endpoint", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_rum_sites("acc-1", order_by = "host")
    expect_match(cap$req$url, "accounts/acc-1/rum/site_info/list")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$order_by, "host")
  })

  it("returns a data.frame of site records from a cassette", {
    local_mock_auth()
    vcr::use_cassette("rum_sites_one_page", {
      sites <- cf_list_rum_sites("acc-1")
    })
    expect_s3_class(sites, "data.frame")
    expect_equal(nrow(sites), 2L)
    expect_equal(sites$host[1], "example.com")
    expect_equal(sites$site_tag[2], "site-tag-2")
  })

  it("returns a raw list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("rum_sites_one_page", {
      sites <- cf_list_rum_sites("acc-1", as_df = FALSE)
    })
    expect_type(sites, "list")
    expect_length(sites, 2)
    expect_equal(sites[[1]]$host, "example.com")
  })
})

describe("cf_get_rum_site()", {
  it("calls the RUM site_info/{tag} endpoint", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"site_tag":"abc"}}'
    )
    local_mock_auth()
    res <- cf_get_rum_site("acc-1", "abc")
    expect_match(cap$req$url, "accounts/acc-1/rum/site_info/abc$")
    expect_equal(res$site_tag, "abc")
  })
})
