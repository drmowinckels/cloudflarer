# Update a Page Rule

Performs a `PATCH`. Only supply fields you want to change. Targets and
actions are full replacements when supplied.

## Usage

``` r
cf_update_page_rule(
  zone_id,
  rule_id,
  targets = NULL,
  actions = NULL,
  priority = NULL,
  status = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- rule_id:

  Character. Page Rule identifier.

- targets:

  A list of target specifications. The simplest form is a single
  URL-match created by
  [`cf_page_rule_target()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_target.md);
  see the example below.

- actions:

  A list of action specifications. The simplest form is a list created
  by
  [`cf_page_rule_action()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_action.md).

- priority:

  Integer. Higher number = applied first.

- status:

  `"active"` or `"disabled"`.

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

A named list describing the updated rule.

## See also

Other zones:
[`cf_create_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_create_page_rule.md),
[`cf_delete_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_page_rule.md),
[`cf_get_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_get_page_rule.md),
[`cf_get_zone()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone.md),
[`cf_get_zone_setting()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone_setting.md),
[`cf_get_zone_settings()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone_settings.md),
[`cf_list_firewall_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_firewall_rules.md),
[`cf_list_page_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_page_rules.md),
[`cf_list_zones()`](http://drmowinckels.io/cloudflarer/reference/cf_list_zones.md),
[`cf_page_rule_action()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_action.md),
[`cf_page_rule_target()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_target.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_update_page_rule(zone_id, "rule-1", status = "disabled")
} # }
```
