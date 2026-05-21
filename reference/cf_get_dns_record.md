# Get a single DNS record

Get a single DNS record

## Usage

``` r
cf_get_dns_record(
  zone_id,
  record_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- record_id:

  Character. DNS record identifier.

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

A named list describing the record.

## See also

Other dns:
[`cf_create_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_dns_record.md),
[`cf_delete_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_dns_record.md),
[`cf_list_dns_records()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_dns_records.md),
[`cf_update_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_dns_record.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_dns_record("zone-1", "rec-1")
} # }
```
