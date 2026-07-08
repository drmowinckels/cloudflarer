# Delete a healthcheck

Delete a healthcheck

## Usage

``` r
cf_delete_healthcheck(
  zone_id,
  healthcheck_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- healthcheck_id:

  Character. Healthcheck identifier.

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

A named list with the deleted healthcheck's `id`.

## See also

Other healthchecks:
[`cf_create_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_create_healthcheck.md),
[`cf_get_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_get_healthcheck.md),
[`cf_list_healthchecks()`](http://drmowinckels.io/cloudflarer/reference/cf_list_healthchecks.md),
[`cf_update_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_update_healthcheck.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_delete_healthcheck("zone-1", "hc-1")
} # }
```
