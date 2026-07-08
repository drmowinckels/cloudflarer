# Get a single healthcheck

Get a single healthcheck

## Usage

``` r
cf_get_healthcheck(
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

A named list describing the healthcheck.

## See also

Other healthchecks:
[`cf_create_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_create_healthcheck.md),
[`cf_delete_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_healthcheck.md),
[`cf_list_healthchecks()`](http://drmowinckels.io/cloudflarer/reference/cf_list_healthchecks.md),
[`cf_update_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_update_healthcheck.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_healthcheck("zone-1", "hc-1")
} # }
```
