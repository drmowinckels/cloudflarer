# Verify the active Cloudflare credential

For token auth, calls `/user/tokens/verify` and returns the token
record. For Global API Key auth, calls `/user` and returns the user
record (the verify endpoint is token-only). Either way, a successful
return means the credential authenticates against the API.

## Usage

``` r
cf_verify(token = NULL, email = NULL, api_key = NULL)

cf_token_verify(token = NULL)
```

## Arguments

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

A named list. The shape depends on the auth mode.

## See also

Other authentication:
[`cf_api_key()`](https://drmowinckels.github.io/cloudflarer/reference/cf_api_key.md),
[`cf_auth_mode()`](https://drmowinckels.github.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md),
[`cf_has_auth()`](https://drmowinckels.github.io/cloudflarer/reference/cf_has_auth.md),
[`cf_sitrep()`](https://drmowinckels.github.io/cloudflarer/reference/cf_sitrep.md),
[`cf_token()`](https://drmowinckels.github.io/cloudflarer/reference/cf_token.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_verify()
} # }
```
