# List firewall rules for a zone

Returns the firewall rules (expression-based custom rules) configured
for the zone. This is the classic firewall-rules endpoint; for the newer
Rulesets API use
[`cf_request()`](https://drmowinckels.github.io/cloudflarer/reference/cf_request.md)
against `/zones/{id}/rulesets`.

## Usage

``` r
cf_list_firewall_rules(
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
  [`cf_request_collect()`](https://drmowinckels.github.io/cloudflarer/reference/cf_request_collect.md).

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

A data.frame of firewall rules (or list when `as_df = FALSE`). Each
rule's `filter` nested object becomes a list-column.

## See also

Other zones:
[`cf_create_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_page_rule.md),
[`cf_delete_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_page_rule.md),
[`cf_get_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_page_rule.md),
[`cf_get_zone()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone.md),
[`cf_get_zone_setting()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_setting.md),
[`cf_get_zone_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_settings.md),
[`cf_list_page_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_page_rules.md),
[`cf_list_zones()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_zones.md),
[`cf_page_rule_action()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_action.md),
[`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md),
[`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_firewall_rules("abc123")
} # }
```
