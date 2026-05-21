# Get a single R2 bucket

Get a single R2 bucket

## Usage

``` r
cf_get_r2_bucket(
  account_id,
  bucket_name,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- bucket_name:

  Character. R2 bucket name.

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

A named list describing the bucket.

## See also

Other r2:
[`cf_list_r2_buckets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_r2_buckets.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_r2_bucket("abc123", "my-bucket")
} # }
```
