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
[`cf_cache_ratio()`](https://drmowinckels.github.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](https://drmowinckels.github.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_graphql()`](https://drmowinckels.github.io/cloudflarer/reference/cf_graphql.md),
[`cf_list_rum_sites()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_rum_site("acc-1", "abc-tag")
} # }
```
