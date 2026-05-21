# Cloudflare account email (legacy auth)

Reads the account email used together with
[`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md)
for Cloudflare's legacy Global API Key authentication. Defaults to
`Sys.getenv("CLOUDFLARE_EMAIL")`.

## Usage

``` r
cf_email(email = NULL)
```

## Arguments

- email:

  Character. Account email. If `NULL` (the default), reads from the
  `CLOUDFLARE_EMAIL` environment variable.

## Value

A character scalar with the email address.

## See also

Other authentication:
[`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md),
[`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_has_auth()`](http://drmowinckels.io/cloudflarer/reference/cf_has_auth.md),
[`cf_sitrep()`](http://drmowinckels.io/cloudflarer/reference/cf_sitrep.md),
[`cf_token()`](http://drmowinckels.io/cloudflarer/reference/cf_token.md),
[`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_email()
} # }
```
