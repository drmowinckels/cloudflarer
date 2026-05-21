# List Workers scripts in an account

Returns the Workers scripts deployed in the supplied account.

## Usage

``` r
cf_list_workers_scripts(
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
  [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md).
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

A data.frame of Workers script records (or list when `as_df = FALSE`).

## See also

Other workers:
[`cf_get_kv_namespace()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_get_workers_script()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_namespaces()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_workers_scripts("abc123")
} # }
```
