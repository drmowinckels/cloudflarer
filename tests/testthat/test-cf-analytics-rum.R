describe("cf_rum_page_views()", {
  it("returns a daily page-view data.frame", {
    local_mock_auth()
    vcr::use_cassette("rum_page_views", {
      df <- cf_rum_page_views(
        "acc-1",
        site_tag = "site-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21")
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(df, c("date", "pageviews"))
    expect_equal(nrow(df), 2L)
    expect_equal(df$pageviews, c(300L, 450L))
  })

  it("returns an empty data.frame when there are no groups", {
    local_mocked_bindings(
      cf_graphql = function(...) {
        list(
          data = list(
            viewer = list(
              accounts = list(list(
                rumPageloadEventsAdaptiveGroups = list()
              ))
            )
          )
        )
      }
    )
    df <- cf_rum_page_views(
      "acc-1",
      site_tag = "x",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_equal(nrow(df), 0L)
  })
})

describe("cf_rum_top()", {
  it("returns a data.frame with the dimension as the first column", {
    local_mock_auth()
    vcr::use_cassette("rum_top_countries", {
      df <- cf_rum_top(
        "acc-1",
        site_tag = "site-1",
        since = as.Date("2026-05-14"),
        until = as.Date("2026-05-21"),
        dimension = "countryName",
        limit = 10
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(df, c("countryName", "count"))
    expect_equal(nrow(df), 3L)
    expect_equal(df$countryName[1], "Norway")
    expect_equal(df$count, c(1200L, 800L, 450L))
  })

  it("respects the dimension argument when building the query", {
    captured <- NULL
    local_mocked_bindings(
      cf_graphql = function(query, ...) {
        captured <<- query
        list(
          data = list(
            viewer = list(
              accounts = list(list(
                rumPageloadEventsAdaptiveGroups = list()
              ))
            )
          )
        )
      }
    )
    cf_rum_top(
      "acc-1",
      site_tag = "x",
      since = as.Date("2026-05-14"),
      until = as.Date("2026-05-21"),
      dimension = "requestPath"
    )
    expect_match(captured, "requestPath")
  })
})
