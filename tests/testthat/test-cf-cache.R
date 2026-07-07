describe("cf_purge_cache()", {
  it("aborts when no targets are supplied", {
    expect_error(cf_purge_cache("zone-1"), "Nothing to purge")
  })

  it("sends purge_everything = TRUE", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"job-1"}}'
    )
    local_mock_auth()
    cf_purge_cache("zone-1", purge_everything = TRUE)
    expect_match(cap$req$url, "zones/zone-1/purge_cache")
    expect_equal(cap$req$method, "POST")
    expect_equal(cap$req$body$data, list(purge_everything = TRUE))
  })

  it("sends only the targeted fields when files supplied", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"job-2"}}'
    )
    local_mock_auth()
    cf_purge_cache("zone-1", files = c("https://x/a", "https://x/b"))
    body <- cap$req$body$data
    expect_equal(body$files, c("https://x/a", "https://x/b"))
    expect_false("hosts" %in% names(body))
  })

  it("returns the purge job id from a cassette", {
    local_mock_auth()
    vcr::use_cassette("purge_cache", {
      res <- cf_purge_cache("zone-1", files = "https://example.com/index.html")
    })
    expect_equal(res$id, "9c2d8e6f0a13")
  })
})
