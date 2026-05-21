# Daily page views for a Web Analytics (RUM) site

Convenience wrapper around the GraphQL `rumPageloadEventsAdaptiveGroups`
node with a daily (`date_DAY`) dimension. Returns a tidy data.frame.

## Usage

``` r
cf_rum_page_views(
  account_id,
  site_tag,
  since,
  until,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier (`accountTag` in GraphQL).

- site_tag:

  Character. RUM site tag, as returned by
  [`cf_list_rum_sites()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rum_sites.md).

- since, until:

  Date or `POSIXct` (or pre-formatted ISO-8601 character strings).
  Half-open `[since, until)` interval.

- limit:

  Maximum number of days to return. Cloudflare caps the underlying query
  at 10000.

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

A data.frame with one row per day and columns `date` (chr) and
`pageviews` (int).

## See also

Other analytics:
[`cf_cache_ratio()`](https://drmowinckels.github.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](https://drmowinckels.github.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_graphql()`](https://drmowinckels.github.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_rum_page_views(
  "acc-1",
  site_tag = "abc",
  since = Sys.Date() - 30,
  until = Sys.Date()
)
} # }
```
