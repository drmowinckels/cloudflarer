# List Email Routing destination addresses

Returns the verified destination addresses available for routing in the
account. Destinations are account-scoped, not zone-scoped, because the
same destination can be used across multiple routed zones.

## Usage

``` r
cf_list_email_routing_addresses(
  account_id,
  verified_only = FALSE,
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

- verified_only:

  Logical. When `TRUE`, asks the API to return only verified addresses.

- per_page, max_pages:

  Pagination controls.

- as_df:

  Logical. See
  [`cf_list_email_routing_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_email_routing_rules.md).

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

A data.frame of destination addresses (or list when `as_df = FALSE`).

## See also

Other email:
[`cf_get_email_routing_settings()`](http://drmowinckels.io/cloudflarer/reference/cf_get_email_routing_settings.md),
[`cf_list_email_routing_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_email_routing_rules.md)

## Examples

``` r
cf_list_email_routing_addresses("abc123")
#> # A tibble: 2 × 3
#>   id     email            verified            
#> * <chr>  <chr>            <chr>               
#> 1 addr-1 you@example.com  2026-05-01T00:00:00Z
#> 2 addr-2 team@example.com NA                  
```
