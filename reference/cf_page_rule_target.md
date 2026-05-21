# Build a Page Rule URL-match target

Produces the nested list that the Cloudflare API expects for the most
common Page Rule target: a URL pattern with `matches` semantics
(asterisks act as wildcards). Use it inside a `targets = list(...)`
argument to
[`cf_create_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_create_page_rule.md).

## Usage

``` r
cf_page_rule_target(url_pattern)
```

## Arguments

- url_pattern:

  Character. The URL pattern, for example `"*example.com/blog/*"`.

## Value

A named list ready to splice into `targets`.

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
[`cf_update_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
cf_page_rule_target("*example.com/blog/*")
#> $target
#> [1] "url"
#> 
#> $constraint
#> $constraint$operator
#> [1] "matches"
#> 
#> $constraint$value
#> [1] "*example.com/blog/*"
#> 
#> 
```
