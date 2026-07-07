# List Rulesets for an account

Returns the rulesets configured at the account level (typically the
curated managed rulesets you can deploy with overrides).

## Usage

``` r
cf_list_account_rulesets(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
  Set to `FALSE` for the raw nested list.

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

A data.frame of rulesets (or list when `as_df = FALSE`).

## See also

Other rulesets:
[`cf_get_account_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_account_ruleset.md),
[`cf_get_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_ruleset.md),
[`cf_list_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rulesets.md)

## Examples

``` r
cf_list_account_rulesets("acc-1")
#> # A tibble: 2 × 4
#>   id    name                          kind    phase                        
#> * <chr> <chr>                         <chr>   <chr>                        
#> 1 rs-1  Cloudflare Managed Ruleset    managed http_request_firewall_managed
#> 2 rs-2  Cloudflare OWASP Core Ruleset managed http_request_firewall_managed
```
