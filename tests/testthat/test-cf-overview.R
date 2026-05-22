make_overview_mock_df <- function(...) {
  d <- data.frame(..., stringsAsFactors = FALSE)
  class(d) <- c("tbl_df", "tbl", "data.frame")
  d
}

describe("cf_zone_overview()", {
  it("assembles every component when all calls succeed", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          requests = c(1000L, 2000L),
          bytes = c(50000000, 100000000),
          pageviews = c(100L, 200L),
          threats = c(5L, 10L),
          uniques = c(50L, 100L)
        )
      },
      cf_cache_ratio = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          requests = c(1000L, 2000L),
          cached_requests = c(700L, 1500L),
          bytes = c(50000000, 100000000),
          cached_bytes = c(35000000, 75000000),
          request_hit_ratio = c(0.7, 0.75),
          bandwidth_hit_ratio = c(0.7, 0.75)
        )
      },
      cf_dns_queries = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          queries = c(5000L, 7500L)
        )
      },
      cf_firewall_events_by_day = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          events = c(12L, 141L)
        )
      },
      cf_rum_top = function(...) {
        make_overview_mock_df(
          countryName = c("Norway", "United States"),
          count = c(1200L, 800L)
        )
      }
    )

    ov <- cf_zone_overview(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-21"),
      account_id = "acc-1",
      site_tag = "site-1"
    )

    expect_s3_class(ov, "cloudflarer_overview")
    expect_named(
      ov,
      c("traffic", "cache", "dns", "firewall", "top_countries", "summary")
    )
    expect_equal(nrow(ov$traffic), 2L)
    expect_equal(nrow(ov$cache), 2L)
    expect_equal(nrow(ov$dns), 2L)
    expect_equal(nrow(ov$firewall), 2L)
    expect_equal(nrow(ov$top_countries), 2L)
    expect_equal(nrow(ov$summary), 1L)

    s <- ov$summary
    expect_equal(s$requests, 3000)
    expect_equal(s$pageviews, 300)
    expect_equal(s$dns_queries, 12500)
    expect_equal(s$firewall_events, 153)
    expect_equal(round(s$cache_hit_ratio, 3), round(2200 / 3000, 3))
    expect_equal(
      round(s$bandwidth_hit_ratio, 3),
      round(110000000 / 150000000, 3)
    )
  })

  it("does not populate top_countries without account_id and site_tag", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = "2026-05-20",
          requests = 1L,
          bytes = 1,
          pageviews = 1L,
          threats = 0L,
          uniques = 1L
        )
      },
      cf_cache_ratio = function(...) NULL,
      cf_dns_queries = function(...) NULL,
      cf_firewall_events_by_day = function(...) NULL
    )
    ov <- cf_zone_overview("zone-1")
    expect_null(ov$top_countries)
  })

  it("survives a Cloudflare-API failure in any one component", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = "2026-05-20",
          requests = 100L,
          bytes = 1000,
          pageviews = 10L,
          threats = 0L,
          uniques = 10L
        )
      },
      cf_cache_ratio = function(...) {
        cli::cli_abort("nope", class = "cloudflarer_error")
      },
      cf_dns_queries = function(...) {
        cli::cli_abort("rate limited", class = "cloudflarer_error")
      },
      cf_firewall_events_by_day = function(...) {
        cli::cli_abort("Pro plan required", class = "cloudflarer_error")
      }
    )
    ov <- cf_zone_overview("zone-1")
    expect_equal(nrow(ov$traffic), 1L)
    expect_null(ov$cache)
    expect_null(ov$dns)
    expect_null(ov$firewall)
    expect_true(is.na(ov$summary$cache_hit_ratio))
    expect_true(is.na(ov$summary$dns_queries))
    expect_true(is.na(ov$summary$firewall_events))
  })

  it("propagates non-cloudflarer errors so bugs are not silenced", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = "2026-05-20",
          requests = 1L,
          bytes = 1,
          pageviews = 1L,
          threats = 0L,
          uniques = 1L
        )
      },
      cf_cache_ratio = function(...) stop("boom"),
      cf_dns_queries = function(...) NULL,
      cf_firewall_events_by_day = function(...) NULL
    )
    expect_error(cf_zone_overview("zone-1"), "boom")
  })

  it("snapshots cleanly when printed", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          requests = c(1000L, 2000L),
          bytes = c(50000000, 100000000),
          pageviews = c(100L, 200L),
          threats = c(5L, 10L),
          uniques = c(50L, 100L)
        )
      },
      cf_cache_ratio = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          requests = c(1000L, 2000L),
          cached_requests = c(700L, 1500L),
          bytes = c(50000000, 100000000),
          cached_bytes = c(35000000, 75000000),
          request_hit_ratio = c(0.7, 0.75),
          bandwidth_hit_ratio = c(0.7, 0.75)
        )
      },
      cf_dns_queries = function(...) {
        make_overview_mock_df(
          date = c("2026-05-19", "2026-05-20"),
          queries = c(5000L, 7500L)
        )
      },
      cf_firewall_events_by_day = function(...) NULL
    )
    ov <- cf_zone_overview(
      "zone-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-21")
    )
    expect_snapshot(print(ov))
  })

  it("snapshots both firewall and top_countries when present", {
    local_mocked_bindings(
      cf_zone_requests = function(...) {
        make_overview_mock_df(
          date = "2026-05-20",
          requests = 100L,
          bytes = 1000,
          pageviews = 10L,
          threats = 1L,
          uniques = 5L
        )
      },
      cf_cache_ratio = function(...) {
        make_overview_mock_df(
          date = "2026-05-20",
          requests = 100L,
          cached_requests = 50L,
          bytes = 1000,
          cached_bytes = 500,
          request_hit_ratio = 0.5,
          bandwidth_hit_ratio = 0.5
        )
      },
      cf_dns_queries = function(...) {
        make_overview_mock_df(date = "2026-05-20", queries = 200L)
      },
      cf_firewall_events_by_day = function(...) {
        make_overview_mock_df(date = "2026-05-20", events = 7L)
      },
      cf_rum_top = function(...) {
        make_overview_mock_df(
          countryName = c("Norway", "Sweden", "Germany"),
          count = c(100L, 50L, 25L)
        )
      }
    )
    ov <- cf_zone_overview(
      "zone-1",
      since = as.Date("2026-05-20"),
      until = as.Date("2026-05-21"),
      account_id = "acc-1",
      site_tag = "site-1"
    )
    expect_snapshot(print(ov))
  })
})
