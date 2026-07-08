# Top dimensions for a Web Analytics (RUM) site

Generic wrapper that groups RUM page-load events by a single dimension
(country, path, referer, browser, OS, device type, ...) and returns the
top entries by count.

## Usage

``` r
cf_rum_top(
  account_id,
  site_tag,
  since,
  until,
  dimension = "countryName",
  limit = 25L,
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
  [`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md).

- since, until:

  Date or `POSIXct` (or pre-formatted ISO-8601 character strings).
  Half-open `[since, until)` interval.

- dimension:

  Character. A dimension name supported by
  `rumPageloadEventsAdaptiveGroups`. Common choices: `"countryName"`,
  `"requestPath"`, `"refererHost"`, `"userAgentBrowser"`,
  `"userAgentOS"`, `"deviceType"`. Must be a single field name (letters,
  digits, underscores; not starting with a digit) and cannot be
  `"count"`, which names the metric column.

- limit:

  Number of rows to return (default 25).

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

A data.frame with two columns: the requested `dimension` and `count`.

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
cf_rum_top(
  "acc-1",
  site_tag = "abc",
  since = Sys.Date() - 7,
  until = Sys.Date(),
  dimension = "countryName",
  limit = 10
)
#> # A tibble: 2 × 2
#>   countryName   count
#>   <chr>         <int>
#> 1 United States   300
#> 2 Germany         120
```
