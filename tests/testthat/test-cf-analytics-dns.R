describe("cf_dns_queries()", {
  it("returns a daily DNS-query data.frame", {
    local_mock_auth()
    vcr::use_cassette("dns_queries_daily", {
      df <- cf_dns_queries(
        "zone-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21")
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(df, c("date", "queries"))
    expect_equal(df$queries, c(5000L, 7500L))
  })

  it("returns an empty data.frame when there are no groups", {
    local_mocked_bindings(
      cf_graphql = function(...) {
        list(
          data = list(
            viewer = list(
              zones = list(list(
                dnsAnalyticsAdaptiveGroups = list()
              ))
            )
          )
        )
      }
    )
    df <- cf_dns_queries(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_equal(nrow(df), 0L)
  })
})
