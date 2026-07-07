# List Web Analytics (RUM) sites

Lists sites configured with the Cloudflare Web Analytics beacon in the
supplied account. Web Analytics works on any site that includes the
beacon snippet, whether or not the site is proxied through Cloudflare.

## Usage

``` r
cf_list_rum_sites(
  account_id,
  order_by = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- order_by:

  Optional column name to sort by, for example `"created"` or `"host"`.

- per_page, max_pages:

  Pagination controls, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
  Set to `FALSE` to get the raw nested list.

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

A data.frame of site records (or list when `as_df = FALSE`).

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md),
[`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
cf_list_rum_sites("acc-1")
#> # A tibble: 2 × 3
#>   site_tag host        created             
#> * <chr>    <chr>       <chr>               
#> 1 abc-tag  example.com 2026-05-01T00:00:00Z
#> 2 def-tag  example.org 2026-05-02T00:00:00Z
```
