# Get a single zone Ruleset (with its rules)

Get a single zone Ruleset (with its rules)

## Usage

``` r
cf_get_ruleset(zone_id, ruleset_id, token = NULL, email = NULL, api_key = NULL)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- ruleset_id:

  Character. Ruleset identifier.

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

A named list describing the ruleset; its `rules` element is itself a
list of rule objects.

## See also

Other rulesets:
[`cf_get_account_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_account_ruleset.md),
[`cf_list_account_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_account_rulesets.md),
[`cf_list_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rulesets.md)

## Examples

``` r
cf_get_ruleset("abc123", "rs-1")
#> $id
#> [1] "rs-1"
#> 
#> $name
#> [1] "default"
#> 
#> $kind
#> [1] "zone"
#> 
#> $phase
#> [1] "http_request_firewall_custom"
#> 
#> $rules
#> $rules[[1]]
#> $rules[[1]]$id
#> [1] "rule-1"
#> 
#> $rules[[1]]$action
#> [1] "block"
#> 
#> $rules[[1]]$expression
#> [1] "ip.src eq 192.0.2.1"
#> 
#> 
#> 
```
