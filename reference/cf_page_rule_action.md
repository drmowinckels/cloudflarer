# Build a Page Rule action

Produces the nested list that the Cloudflare API expects for a single
Page Rule action. Use it inside an `actions = list(...)` argument to
[`cf_create_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_page_rule.md)
or
[`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md).

## Usage

``` r
cf_page_rule_action(id, value)
```

## Arguments

- id:

  Character. The action name (Cloudflare's "setting" identifier).

- value:

  The value to set. For most actions this is a character or integer
  scalar; some (for example `"forwarding_url"`) expect a nested list.

## Value

A named list ready to splice into `actions`.

## Details

Common `id` values: `"cache_level"`, `"edge_cache_ttl"`,
`"browser_cache_ttl"`, `"always_use_https"`, `"security_level"`,
`"ssl"`, `"forwarding_url"`.

## See also

Other zones:
[`cf_create_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_page_rule.md),
[`cf_delete_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_page_rule.md),
[`cf_get_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_page_rule.md),
[`cf_get_zone()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone.md),
[`cf_get_zone_setting()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_setting.md),
[`cf_get_zone_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_settings.md),
[`cf_list_firewall_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_firewall_rules.md),
[`cf_list_page_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_page_rules.md),
[`cf_list_zones()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_zones.md),
[`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md),
[`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
cf_page_rule_action("cache_level", "cache_everything")
#> $id
#> [1] "cache_level"
#> 
#> $value
#> [1] "cache_everything"
#> 
cf_page_rule_action("edge_cache_ttl", 7200)
#> $id
#> [1] "edge_cache_ttl"
#> 
#> $value
#> [1] 7200
#> 
cf_page_rule_action(
  "forwarding_url",
  list(url = "https://example.com/$1", status_code = 301)
)
#> $id
#> [1] "forwarding_url"
#> 
#> $value
#> $value$url
#> [1] "https://example.com/$1"
#> 
#> $value$status_code
#> [1] 301
#> 
#> 
```
