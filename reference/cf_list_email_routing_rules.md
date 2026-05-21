# List Email Routing rules for a zone

Returns the address-matching rules that decide how incoming emails are
forwarded.

## Usage

``` r
cf_list_email_routing_rules(
  zone_id,
  enabled_only = FALSE,
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

- enabled_only:

  Logical. When `TRUE`, asks the API to return only enabled rules.

- per_page, max_pages:

  Pagination controls, see
  [`cf_request_collect()`](https://drmowinckels.github.io/cloudflarer/reference/cf_request_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md).

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

A data.frame of routing rules (or list when `as_df = FALSE`).

## See also

Other email:
[`cf_get_email_routing_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_email_routing_settings.md),
[`cf_list_email_routing_addresses()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_email_routing_addresses.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_email_routing_rules("abc123")
} # }
```
