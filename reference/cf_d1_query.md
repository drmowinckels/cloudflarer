# Run a SQL query against a D1 database

Executes one or more SQL statements against the database. Use `params`
for parameterised queries to avoid string-interpolation issues.

## Usage

``` r
cf_d1_query(
  account_id,
  database_id,
  sql,
  params = NULL,
  as_df = TRUE,
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

- sql:

  Character. SQL statement(s) to execute.

- params:

  Optional character vector of positional parameters bound to the `?`
  placeholders in `sql`.

- as_df:

  Logical. When `TRUE` (the default), returns the first result set as a
  data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
  Set to `FALSE` to get the full raw response (useful for
  multi-statement queries or when you need the metadata).

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

A data.frame of result rows when `as_df = TRUE`, otherwise the raw
response (a list of result blocks, each with `success`, `meta`, and
`results`).

## See also

Other d1:
[`cf_create_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_create_d1_database.md),
[`cf_delete_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_d1_database.md),
[`cf_get_d1_database()`](http://drmowinckels.io/cloudflarer/reference/cf_get_d1_database.md),
[`cf_list_d1_databases()`](http://drmowinckels.io/cloudflarer/reference/cf_list_d1_databases.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_d1_query("acc-1", "db-1", "SELECT * FROM users WHERE id = ?", params = "42")
} # }
```
