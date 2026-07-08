# Top firewall events for a zone by a chosen dimension

Groups `firewallEventsAdaptiveGroups` by a single dimension and returns
the top entries by count.

## Usage

``` r
cf_firewall_events_top(
  zone_id,
  since,
  until,
  dimension = "action",
  limit = 25L,
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

- dimension:

  Character. Dimension name to group by. Common choices: `"action"`
  (block, challenge, ...), `"source"` (WAF, firewall rules, security
  level, ...), `"ruleId"`, `"clientCountryName"`, `"clientRequestPath"`,
  `"clientRequestHTTPHost"`, `"userAgent"`. Must be a single field name
  (letters, digits, underscores; not starting with a digit) and cannot
  be `"events"`, which names the metric column.

- limit:

  Number of rows to return.

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

A data.frame with two columns: the requested `dimension` and `events`
(the event count).

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
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
cf_firewall_events_top(
  "abc123",
  since = Sys.Date() - 7,
  until = Sys.Date(),
  dimension = "action",
  limit = 10
)
#> # A tibble: 2 × 2
#>   action    events
#>   <chr>      <int>
#> 1 block         30
#> 2 challenge     12
```
