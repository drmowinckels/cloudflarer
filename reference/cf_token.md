# Cloudflare API token

Returns the modern Cloudflare API token. By default reads from the
`CLOUDFLARE_API_TOKEN` environment variable. See
[`vignette("authentication", package = "cloudflarer")`](https://drmowinckels.github.io/cloudflarer/articles/authentication.md)
for guidance on creating a token and storing it safely.

## Usage

``` r
cf_token(token = NULL)
```

## Arguments

- token:

  Character. An API token. If `NULL` (the default), the value of
  `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.

## Value

A character scalar with the API token.

## See also

Other authentication:
[`cf_api_key()`](https://drmowinckels.github.io/cloudflarer/reference/cf_api_key.md),
[`cf_auth_mode()`](https://drmowinckels.github.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md),
[`cf_has_auth()`](https://drmowinckels.github.io/cloudflarer/reference/cf_has_auth.md),
[`cf_sitrep()`](https://drmowinckels.github.io/cloudflarer/reference/cf_sitrep.md),
[`cf_verify()`](https://drmowinckels.github.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_token()
} # }
```
