# Create a Page Rule

Each rule applies a list of `actions` whenever a request matches one of
`targets`. The most common pattern: a single URL-match target plus one
cache-related action (for example `cache_level = "cache_everything"` to
bump a static site's hit ratio).

## Usage

``` r
cf_create_page_rule(
  zone_id,
  targets,
  actions,
  priority = 1L,
  status = c("active", "disabled"),
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- targets:

  A list of target specifications. The simplest form is a single
  URL-match created by
  [`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md);
  see the example below.

- actions:

  A list of action specifications. The simplest form is a list created
  by
  [`cf_page_rule_action()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_action.md).

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

A named list describing the created rule.

## See also

Other zones:
[`cf_delete_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_page_rule.md),
[`cf_get_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_page_rule.md),
[`cf_get_zone()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone.md),
[`cf_get_zone_setting()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_setting.md),
[`cf_get_zone_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_settings.md),
[`cf_list_firewall_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_firewall_rules.md),
[`cf_list_page_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_page_rules.md),
[`cf_list_zones()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_zones.md),
[`cf_page_rule_action()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_action.md),
[`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md),
[`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_create_page_rule(
  zone_id,
  targets = list(
    cf_page_rule_target("*example.com/blog/*")
  ),
  actions = list(
    cf_page_rule_action("cache_level", "cache_everything"),
    cf_page_rule_action("edge_cache_ttl", 7200)
  )
)
} # }
```
