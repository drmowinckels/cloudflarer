# Get a single Web Analytics (RUM) site

Get a single Web Analytics (RUM) site

## Usage

``` r
cf_get_rum_site(
  account_id,
  site_tag,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- site_tag:

  Character. RUM site tag (sometimes called "site identifier").

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

A named list describing the site.

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
cf_get_rum_site("acc-1", "abc-tag")
#> $site_tag
#> [1] "abc-tag"
#> 
#> $host
#> [1] "example.com"
#> 
#> $created
#> [1] "2026-05-01T00:00:00Z"
#> 
```
