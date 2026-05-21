# Cloudflare Global API Key (legacy auth)

Reads the Global API Key used together with
[`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md)
for Cloudflare's legacy authentication scheme. Prefer creating a scoped
API token instead; see
[`cf_token()`](https://drmowinckels.github.io/cloudflarer/reference/cf_token.md).

## Usage

``` r
cf_api_key(api_key = NULL)
```

## Arguments

- api_key:

  Character. The Global API Key. If `NULL` (the default), reads from the
  `CLOUDFLARE_API_KEY` environment variable.

## Value

A character scalar with the API key.

## See also

Other authentication:
[`cf_auth_mode()`](https://drmowinckels.github.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md),
[`cf_has_auth()`](https://drmowinckels.github.io/cloudflarer/reference/cf_has_auth.md),
[`cf_sitrep()`](https://drmowinckels.github.io/cloudflarer/reference/cf_sitrep.md),
[`cf_token()`](https://drmowinckels.github.io/cloudflarer/reference/cf_token.md),
[`cf_verify()`](https://drmowinckels.github.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_api_key()
} # }
```
