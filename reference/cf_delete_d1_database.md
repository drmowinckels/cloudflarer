# Delete a D1 database

Delete a D1 database

## Usage

``` r
cf_delete_d1_database(
  account_id,
  database_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- database_id:

  Character. D1 database `uuid`.

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

A named list with the API response.

## See also

Other d1:
[`cf_create_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_create_d1_database.md),
[`cf_d1_query()`](http://drmowinckels.io/cloudflarer/reference/cf_d1_query.md),
[`cf_get_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_get_d1_database.md),
[`cf_list_d1_databases()`](http://drmowinckels.io/cloudflarer/reference/cf_list_d1_databases.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_delete_d1_database("acc-1", "db-1")
} # }
```
