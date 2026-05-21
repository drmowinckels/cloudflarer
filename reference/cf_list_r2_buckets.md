# List R2 buckets in an account

Returns the R2 object-storage buckets in the supplied account.

## Usage

``` r
cf_list_r2_buckets(
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

A data.frame of bucket records (or list when `as_df = FALSE`).

## See also

Other r2:
[`cf_get_r2_bucket()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_r2_bucket.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_r2_buckets("abc123")
} # }
```
