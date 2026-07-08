# List D1 databases in an account

Returns the D1 (serverless SQL) databases for the account.

## Usage

``` r
cf_list_d1_databases(
  account_id,
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

- account_id:

  Character. Cloudflare account identifier.

- name:

  Optional name filter (substring match).

- per_page, max_pages:

  Pagination controls, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).

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

A data.frame of D1 database records (or list when `as_df = FALSE`).

## See also

Other d1:
[`cf_create_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_create_d1_database.md),
[`cf_d1_query()`](http://drmowinckels.io/cloudflarer/reference/cf_d1_query.md),
[`cf_delete_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_d1_database.md),
[`cf_get_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_get_d1_database.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_d1_databases("acc-1")
} # }
```
