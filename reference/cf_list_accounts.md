# List accounts

Lists all accounts the authenticated user has access to.

## Usage

``` r
cf_list_accounts(
  name = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- name:

  Optional name filter passed to the API.

- per_page:

  Page size, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- max_pages:

  Maximum number of pages to retrieve, see
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

A data.frame of account records (or a list when `as_df = FALSE`).

## See also

Other accounts:
[`cf_get_account()`](http://drmowinckels.io/cloudflarer/reference/cf_get_account.md)

## Examples

``` r
cf_list_accounts()
#> # A tibble: 2 × 2
#>   id     name       
#> * <chr>  <chr>      
#> 1 abc123 Example Org
#> 2 def456 Second Org 
```
