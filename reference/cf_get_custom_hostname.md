# Get a single custom hostname

Get a single custom hostname

## Usage

``` r
cf_get_custom_hostname(
  zone_id,
  custom_hostname_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- custom_hostname_id:

  Character. Custom hostname identifier.

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

A named list describing the custom hostname.

## See also

Other ssl:
[`cf_create_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_create_custom_hostname.md),
[`cf_delete_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_custom_hostname.md),
[`cf_get_certificate_pack()`](http://drmowinckels.io/cloudflarer/reference/cf_get_certificate_pack.md),
[`cf_list_certificate_packs()`](http://drmowinckels.io/cloudflarer/reference/cf_list_certificate_packs.md),
[`cf_list_custom_hostnames()`](http://drmowinckels.io/cloudflarer/reference/cf_list_custom_hostnames.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_custom_hostname("zone-1", "ch-1")
} # }
```
