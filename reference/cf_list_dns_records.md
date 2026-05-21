# List DNS records in a zone

List DNS records in a zone

## Usage

``` r
cf_list_dns_records(
  zone_id,
  type = NULL,
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

- zone_id:

  Character. Cloudflare zone identifier.

- type:

  Optional record type filter, for example `"A"` or `"CNAME"`.

- name:

  Optional record name filter.

- per_page:

  Page size, see
  [`cf_request_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_request_collect.md).

- max_pages:

  Maximum pages to retrieve, see
  [`cf_request_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_request_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
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

A data.frame of DNS records (or list when `as_df = FALSE`).

## See also

Other dns:
[`cf_create_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_create_dns_record.md),
[`cf_delete_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_dns_record.md),
[`cf_get_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_get_dns_record.md),
[`cf_update_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_update_dns_record.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_dns_records("abc123")
cf_list_dns_records("abc123", type = "A")
} # }
```
