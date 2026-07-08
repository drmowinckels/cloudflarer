# Workers invocations over time

Wraps the Cloudflare GraphQL `workersInvocationsAdaptive` node to return
a tidy data.frame with one row per time bin and one row per Worker
script.

## Usage

``` r
cf_workers_invocations(
  account_id,
  since,
  until,
  script_name = NULL,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier (`accountTag` in GraphQL).

- since, until:

  Date or `POSIXct`. Half-open `[since, until)`.

- script_name:

  Optional Worker script name filter.

- limit:

  Maximum number of rows.

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

A data.frame with columns `date`, `script`, `requests`, `errors`,
`subrequests`, `duration_ms`.

## Details

Requires an API token with `Account Analytics: Read` (or the legacy
Global API Key).

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
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

Other workers:
[`cf_create_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_create_kv_namespace.md),
[`cf_delete_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_namespace.md),
[`cf_delete_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_value.md),
[`cf_delete_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_values.md),
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_get_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_value.md),
[`cf_get_workers_script()`](http://drmowinckels.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_keys()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_keys.md),
[`cf_list_kv_namespaces()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_put_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_value.md),
[`cf_put_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_values.md),
[`cf_rename_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_rename_kv_namespace.md)

## Examples

``` r
cf_workers_invocations(
  "acc-1",
  since = Sys.Date() - 7,
  until = Sys.Date()
)
#> # A tibble: 1 × 7
#>   date       script      requests errors subrequests cpu_p50_us cpu_p99_us
#>   <chr>      <chr>          <int>  <int>       <int>      <dbl>      <dbl>
#> 1 2026-05-01 hello-world    10000      5        2000        1.2        8.5
```
