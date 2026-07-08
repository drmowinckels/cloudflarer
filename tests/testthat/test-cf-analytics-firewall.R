describe("cf_firewall_events_by_day()", {
  it("returns a daily firewall-events data.frame", {
    local_mock_auth()
    vcr::use_cassette("firewall_events_by_day", {
      df <- cf_firewall_events_by_day(
        "zone-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21")
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(df, c("date", "events"))
    expect_equal(nrow(df), 2L)
    expect_equal(df$events, c(12L, 141L))
  })

  it("returns an empty data.frame when there are no groups", {
    local_mocked_bindings(
      cf_graphql = function(...) {
        list(
          data = list(
            viewer = list(
              zones = list(list(
                firewallEventsAdaptiveGroups = list()
              ))
            )
          )
        )
      }
    )
    df <- cf_firewall_events_by_day(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_equal(nrow(df), 0L)
  })
})

describe("cf_firewall_events_top()", {
  it("returns top events by chosen dimension", {
    local_mock_auth()
    vcr::use_cassette("firewall_events_top_action", {
      df <- cf_firewall_events_top(
        "zone-1",
        since = as.Date("2026-05-14"),
        until = as.Date("2026-05-21"),
        dimension = "action",
        limit = 10
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(df, c("action", "events"))
    expect_equal(df$action[1], "block")
    expect_equal(df$events, c(100L, 40L, 13L))
  })

  it("respects the dimension argument when building the query", {
    captured <- NULL
    local_mocked_bindings(
      cf_graphql = function(query, ...) {
        captured <<- query
        list(
          data = list(
            viewer = list(
              zones = list(list(
                firewallEventsAdaptiveGroups = list()
              ))
            )
          )
        )
      }
    )
    cf_firewall_events_top(
      "zone-1",
      since = as.Date("2026-05-14"),
      until = as.Date("2026-05-21"),
      dimension = "clientCountryName"
    )
    expect_match(captured, "clientCountryName")
  })

  it("aborts when dimension collides with the events metric column", {
    expect_error(
      cf_firewall_events_top(
        "zone-1",
        since = as.Date("2026-05-14"),
        until = as.Date("2026-05-21"),
        dimension = "events"
      ),
      "cannot be"
    )
  })

  it("aborts before making a request when dimension is not a valid field name", {
    local_mocked_bindings(
      cf_graphql = function(...) cli::cli_abort("should not be called")
    )
    expect_error(
      cf_firewall_events_top(
        "zone-1",
        since = as.Date("2026-05-14"),
        until = as.Date("2026-05-21"),
        dimension = "clientCountryName } avg { sampleInterval"
      ),
      "field name"
    )
  })
})
