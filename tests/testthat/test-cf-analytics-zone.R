describe("cf_zone_requests()", {
  it("returns a tidy data.frame from a daily cassette", {
    local_mock_auth()
    vcr::use_cassette("zone_requests_daily", {
      df <- cf_zone_requests(
        "zone-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21"),
        by = "day"
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(
      df,
      c("date", "requests", "bytes", "pageviews", "threats", "uniques")
    )
    expect_equal(nrow(df), 2L)
    expect_equal(df$date, c("2026-05-19", "2026-05-20"))
    expect_equal(df$requests, c(1000L, 4027L))
    expect_equal(df$uniques, c(150L, 808L))
  })

  it("returns an empty data.frame when no groups come back", {
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
    df <- cf_zone_requests(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 0L)
  })

  it("builds an hourly query when by = 'hour'", {
    captured <- NULL
    local_mocked_bindings(
      cf_graphql = function(query, ...) {
        captured <<- query
        list(
          data = list(
            viewer = list(
              zones = list(list(
                httpRequests1hGroups = list()
              ))
            )
          )
        )
      }
    )
    cf_zone_requests(
      "zone-1",
      since = as.POSIXct("2026-05-20 00:00:00", tz = "UTC"),
      until = as.POSIXct("2026-05-20 06:00:00", tz = "UTC"),
      by = "hour"
    )
    expect_match(captured, "httpRequests1hGroups")
    expect_match(captured, "datetime_geq")
    expect_match(captured, "datetime_ASC")
  })
})
