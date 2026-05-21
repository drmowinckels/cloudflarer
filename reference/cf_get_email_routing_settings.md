# Email Routing settings for a zone

Returns the current Email Routing configuration for the zone:
enabled/disabled, SPF/MX status, last-modified timestamps.

## Usage

``` r
cf_get_email_routing_settings(
  zone_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

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

A named list with the routing settings.

## See also

Other email:
[`cf_list_email_routing_addresses()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_email_routing_addresses.md),
[`cf_list_email_routing_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_email_routing_rules.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_email_routing_settings("abc123")
} # }
```
