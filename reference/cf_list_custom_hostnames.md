# List custom hostnames in a zone

Returns the SSL-for-SaaS custom hostnames attached to the zone.

## Usage

``` r
cf_list_custom_hostnames(
  zone_id,
  hostname = NULL,
  ssl = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- hostname:

  Optional hostname filter (substring match).

- ssl:

  Optional SSL status filter (e.g. `"active"`, `"pending_validation"`).

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

A data.frame of custom hostname records (or list when `as_df = FALSE`).

## See also

Other ssl:
[`cf_create_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_create_custom_hostname.md),
[`cf_delete_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_custom_hostname.md),
[`cf_get_certificate_pack()`](http://drmowinckels.io/cloudflarer/reference/cf_get_certificate_pack.md),
[`cf_get_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_get_custom_hostname.md),
[`cf_list_certificate_packs()`](http://drmowinckels.io/cloudflarer/reference/cf_list_certificate_packs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_custom_hostnames("zone-1")
} # }
```
