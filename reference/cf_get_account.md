# Get a single account

Get a single account

## Usage

``` r
cf_get_account(account_id, token = NULL, email = NULL, api_key = NULL)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

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

A named list describing the account.

## See also

Other accounts:
[`cf_list_accounts()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_accounts.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_account("abc123")
} # }
```
