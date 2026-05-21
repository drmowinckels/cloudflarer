# Get a single account Ruleset (with its rules)

Get a single account Ruleset (with its rules)

## Usage

``` r
cf_get_account_ruleset(
  account_id,
  ruleset_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

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
[`cf_get_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_ruleset.md),
[`cf_list_account_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_account_rulesets.md),
[`cf_list_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rulesets.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_account_ruleset("acc-1", "rs-1")
} # }
```
