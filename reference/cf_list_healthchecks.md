# List standalone healthchecks in a zone

Returns the standalone Healthchecks configured in the zone. These are
separate from load-balancer pool monitors.

## Usage

``` r
cf_list_healthchecks(
  zone_id,
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

A data.frame of healthcheck records (or list when `as_df = FALSE`).

## See also

Other healthchecks:
[`cf_create_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_create_healthcheck.md),
[`cf_delete_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_healthcheck.md),
[`cf_get_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_get_healthcheck.md),
[`cf_update_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_update_healthcheck.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_healthchecks("zone-1")
} # }
```
