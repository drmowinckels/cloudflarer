# Daily or hourly HTTP request totals for a zone

Convenience wrapper around the Cloudflare GraphQL Analytics
`httpRequests1dGroups` (daily) or `httpRequests1hGroups` (hourly) nodes.
Returns a tidy data.frame with one row per time bin and columns for
requests, bytes, page views, threats, and unique visitors.

## Usage

``` r
cf_zone_requests(
  zone_id,
  since,
  until,
  by = c("day", "hour"),
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier (`zoneTag` in GraphQL).

- since, until:

  Date or `POSIXct` (or pre-formatted character `"YYYY-MM-DD"` for
  `by = "day"` and `"YYYY-MM-DDTHH:MM:SSZ"` for `by = "hour"`). The
  interval is half-open `[since, until)`.

- by:

  Bin width: `"day"` or `"hour"`.

- limit:

  Maximum number of bins to return. Cloudflare caps the GraphQL query at
  10000.

- token:

  Character. An API token. If `NULL` (the default), the value of
  `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.

- email:

  Character. Account email. If `NULL` (the default), reads from the
  `CLOUDFLARE_EMAIL` environment variable.

- api_key:

  Character. The Global API Key. If `NULL` (the default), reads from the
  `CLOUDFLARE_API_KEY` environment variable.

## Value

A data.frame with columns: `date` (chr; `"YYYY-MM-DD"` for daily,
`"YYYY-MM-DDTHH:00:00Z"` for hourly), `requests`, `bytes`, `pageviews`,
`threats`, `uniques`.

## See also

Other analytics:
[`cf_cache_ratio()`](https://drmowinckels.github.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](https://drmowinckels.github.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_graphql()`](https://drmowinckels.github.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_overview.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_zone_requests(
  "abc123",
  since = Sys.Date() - 7,
  until = Sys.Date(),
  by    = "day"
)

cf_zone_requests(
  "abc123",
  since = Sys.time() - 24 * 3600,
  until = Sys.time(),
  by    = "hour"
)
} # }
```
