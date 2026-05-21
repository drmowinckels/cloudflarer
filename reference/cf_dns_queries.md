# Daily DNS query counts for a zone

Wraps the Cloudflare GraphQL `dnsAnalyticsAdaptiveGroups` node, grouped
by day. Returns a tidy data.frame.

## Usage

``` r
cf_dns_queries(
  zone_id,
  since,
  until,
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

  Date or `POSIXct`. Half-open `[since, until)`.

- limit:

  Maximum number of rows. Cloudflare caps the underlying query at 10000.

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

A data.frame with columns `date` (chr) and `queries` (int).

## Details

Requires an API token with the `Account Analytics: Read` (or
`Zone Analytics: Read`) permission. The legacy Global API Key has full
access.

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_dns_queries(
  "abc123",
  since = Sys.Date() - 7,
  until = Sys.Date()
)
} # }
```
