describe("cf_cache_ratio()", {
  it("returns a tidy data.frame with derived hit ratios", {
    local_mock_auth()
    vcr::use_cassette("cache_ratio_daily", {
      df <- cf_cache_ratio(
        "zone-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21")
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(
      df,
      c(
        "date",
        "requests",
        "cached_requests",
        "bytes",
        "cached_bytes",
        "request_hit_ratio",
        "bandwidth_hit_ratio"
      )
    )
    expect_equal(df$requests, c(1000L, 4027L))
    expect_equal(round(df$request_hit_ratio, 3), c(0.7, 0.869))
    expect_equal(round(df$bandwidth_hit_ratio, 3), c(0.7, 0.861))
  })

  it("returns an empty data.frame when there are no groups", {
    local_mocked_bindings(
      cf_graphql = function(...) {
        list(
          data = list(
            viewer = list(
              zones = list(list(
                httpRequests1dGroups = list()
              ))
            )
          )
        )
      }
    )
    df <- cf_cache_ratio(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_equal(nrow(df), 0L)
  })
})
