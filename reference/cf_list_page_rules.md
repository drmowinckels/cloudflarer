# List Page Rules for a zone

Returns the Page Rules configured for a zone (URL-pattern based
overrides for cache, SSL, security, redirects, etc.).

## Usage

``` r
cf_list_page_rules(
  zone_id,
  status = NULL,
  order = NULL,
  direction = NULL,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- status:

  Optional status filter (`"active"` or `"disabled"`).

- order:

  Optional ordering, see the Cloudflare API reference. For example
  `"priority"` or `"status"`.

- direction:

  Optional sort direction, `"asc"` or `"desc"`.

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md).
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

A data.frame of page rules (or list when `as_df = FALSE`). Each rule's
`targets` and `actions` are kept as list-columns because they are
themselves arrays of nested objects.

## See also

Other zones:
[`cf_create_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_page_rule.md),
[`cf_delete_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_page_rule.md),
[`cf_get_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_page_rule.md),
[`cf_get_zone()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone.md),
[`cf_get_zone_setting()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_setting.md),
[`cf_get_zone_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_settings.md),
[`cf_list_firewall_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_firewall_rules.md),
[`cf_list_zones()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_zones.md),
[`cf_page_rule_action()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_action.md),
[`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md),
[`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_page_rules("abc123")
} # }
```
