# One-call summary of a zone's recent activity

Bundles the most-used analytics endpoints into a single call and returns
a named list of tidy data.frames covering traffic, cache effectiveness,
DNS queries, firewall events, and (when `site_tag` is supplied) Web
Analytics top countries.

## Usage

``` r
cf_zone_overview(
  zone_id,
  since = Sys.Date() - 7,
  until = Sys.Date(),
  account_id = NULL,
  site_tag = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- since, until:

  Date or `POSIXct`. Half-open `[since, until)`. Defaults to the last 7
  days.

- account_id:

  Optional account identifier. Required for the `top_countries` slot.

- site_tag:

  Optional Web Analytics site tag. Required for the `top_countries`
  slot.

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

A named list with class `cloudflarer_overview`:

- `traffic` – daily requests, bytes, page views, threats, uniques (from
  [`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)).

- `cache` – daily cache hit ratios (from
  [`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md)).

- `dns` – daily DNS query counts (from
  [`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md)).

- `firewall` – daily firewall event counts (from
  [`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md);
  Pro+ plans only).

- `top_countries` – top countries by RUM page views (from
  [`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md));
  only populated when `account_id` and `site_tag` are supplied.

- `summary` – a one-row data.frame with the period totals.

## Details

Each underlying call is wrapped in
[`tryCatch()`](https://rdrr.io/r/base/conditions.html), so an individual
failure (Free-plan gating, missing permission, empty data) yields `NULL`
for that component instead of aborting the whole overview.

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
[`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
ov <- cf_zone_overview(zone_id, account_id = account_id, site_tag = site_tag)
ov$traffic
#> # A tibble: 1 × 6
#>   date       requests   bytes pageviews threats uniques
#>   <chr>         <int>   <dbl>     <int>   <int>   <int>
#> 1 2026-05-01     1000 2000000       500      10     300
ov$summary
#> # A tibble: 1 × 11
#>   since      until      requests bytes pageviews uniques threats cache_hit_ratio
#>   <chr>      <chr>         <int> <dbl>     <int>   <int>   <int>           <dbl>
#> 1 2026-06-30 2026-07-07     1000   2e6       500     300      10             0.8
#> # ℹ 3 more variables: bandwidth_hit_ratio <dbl>, dns_queries <int>,
#> #   firewall_events <int>
```
