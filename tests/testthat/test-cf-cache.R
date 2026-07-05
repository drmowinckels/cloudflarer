describe("cf_purge_cache()", {
  it("aborts when no targets are supplied", {
    expect_error(cf_purge_cache("zone-1"), "Nothing to purge")
  })

  it("sends purge_everything = TRUE", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- list(endpoint = endpoint, method = method, body = body)
        list(id = "job-1")
      }
    )
    cf_purge_cache("zone-1", purge_everything = TRUE)
    expect_equal(captured$endpoint, c("zones", "zone-1", "purge_cache"))
    expect_equal(captured$method, "POST")
    expect_equal(captured$body, list(purge_everything = TRUE))
  })

  it("sends only the targeted fields when files supplied", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- body
        list(id = "job-2")
      }
    )
    cf_purge_cache("zone-1", files = c("https://x/a", "https://x/b"))
    expect_equal(captured$files, c("https://x/a", "https://x/b"))
    expect_false("hosts" %in% names(captured))
  })

  it("returns the purge job id from a cassette", {
    local_mock_auth()
    vcr::use_cassette("purge_cache", {
      res <- cf_purge_cache("zone-1", files = "https://example.com/index.html")
    })
    expect_equal(res$id, "9c2d8e6f0a13")
  })
})
