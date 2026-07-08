# Create a custom hostname

Registers a customer hostname with SSL-for-SaaS.

## Usage

``` r
cf_create_custom_hostname(
  zone_id,
  hostname,
  ssl_method = "txt",
  ssl_type = "dv",
  ssl = NULL,
  custom_metadata = NULL,
  custom_origin_server = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- hostname:

  Customer-facing hostname (e.g. `"shop.customer.com"`).

- ssl_method:

  Domain Control Validation method: `"http"`, `"txt"`, or `"email"`.

- ssl_type:

  Certificate type, typically `"dv"`.

- ssl:

  Optional named list overriding the default SSL config. When supplied,
  takes precedence over `ssl_method` / `ssl_type`.

- custom_metadata:

  Optional named list of metadata stored with the hostname.

- custom_origin_server:

  Optional custom origin server (overrides zone fallback).

- ...:

  Additional fields forwarded to the API.

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

A named list describing the created custom hostname.

## See also

Other ssl:
[`cf_delete_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_custom_hostname.md),
[`cf_get_certificate_pack()`](http://drmowinckels.io/cloudflarer/reference/cf_get_certificate_pack.md),
[`cf_get_custom_hostname()`](http://drmowinckels.io/cloudflarer/reference/cf_get_custom_hostname.md),
[`cf_list_certificate_packs()`](http://drmowinckels.io/cloudflarer/reference/cf_list_certificate_packs.md),
[`cf_list_custom_hostnames()`](http://drmowinckels.io/cloudflarer/reference/cf_list_custom_hostnames.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_create_custom_hostname(
  "zone-1",
  hostname   = "shop.customer.com",
  ssl_method = "txt"
)
} # }
```
