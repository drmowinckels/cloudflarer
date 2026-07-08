# Update a healthcheck

Performs a `PATCH`, sending only fields supplied as non-`NULL`.

## Usage

``` r
cf_update_healthcheck(
  zone_id,
  healthcheck_id,
  name = NULL,
  address = NULL,
  type = NULL,
  check_regions = NULL,
  http_config = NULL,
  tcp_config = NULL,
  interval = NULL,
  retries = NULL,
  timeout = NULL,
  description = NULL,
  suspended = NULL,
  ...,
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

- name:

  Display name for the healthcheck.

- address:

  Hostname or IPv4/IPv6 address to monitor.

- type:

  One of `"HTTPS"`, `"HTTP"`, or `"TCP"`.

- check_regions:

  Optional character vector of Cloudflare region codes (`"WEU"`,
  `"ENAM"`, etc.). When `NULL`, the API runs the check from all
  available regions.

- http_config:

  Optional named list with HTTP/HTTPS-specific fields (`path`, `port`,
  `method`, `expected_codes`, `expected_body`, `follow_redirects`,
  `allow_insecure`, `header`).

- tcp_config:

  Optional named list with TCP-specific fields (`port`, `method`).

- interval:

  Polling interval in seconds.

- retries:

  Number of retries before marking unhealthy.

- timeout:

  Timeout per check, in seconds.

- description:

  Optional human-readable description.

- suspended:

  Logical. When `TRUE`, the check is paused.

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

A named list describing the updated healthcheck.

## See also

Other healthchecks:
[`cf_create_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_create_healthcheck.md),
[`cf_delete_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_healthcheck.md),
[`cf_get_healthcheck()`](http://drmowinckels.io/cloudflarer/reference/cf_get_healthcheck.md),
[`cf_list_healthchecks()`](http://drmowinckels.io/cloudflarer/reference/cf_list_healthchecks.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_update_healthcheck("zone-1", "hc-1", suspended = TRUE)
} # }
```
