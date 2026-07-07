# List zones

Lists the zones (domains) accessible to the authenticated credential.

## Usage

``` r
cf_list_zones(
  name = NULL,
  status = NULL,
  account_id = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- name:

  Optional zone name to filter by.

- status:

  Optional status filter (for example `"active"`).

- account_id:

  Optional account identifier to scope the listing.

- per_page:

  Page size, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- max_pages:

  Maximum pages to retrieve, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
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

A data.frame of zone records (or a list when `as_df = FALSE`).

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
[`cf_page_rule_action()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_action.md),
[`cf_page_rule_target()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_target.md),
[`cf_update_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_update_page_rule.md)

## Examples

``` r
cf_list_zones()
#> # A tibble: 2 × 3
#>   id     name        status
#> * <chr>  <chr>       <chr> 
#> 1 abc123 example.com active
#> 2 def456 example.org active
cf_list_zones(name = "example.com")
#> # A tibble: 1 × 3
#>   id     name        status
#> * <chr>  <chr>       <chr> 
#> 1 abc123 example.com active
```
