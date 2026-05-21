# Detect which Cloudflare auth mode is configured

Returns the credential type that the next request would use, based on
the current environment:

## Usage

``` r
cf_auth_mode()
```

## Value

A character scalar (`"token"`, `"key"`, or `NA_character_`).

## Details

- `"token"` – `CLOUDFLARE_API_TOKEN` is set.

- `"key"` – both `CLOUDFLARE_EMAIL` and `CLOUDFLARE_API_KEY` are set.

- `NA_character_` – no usable credentials are available.

When both are configured, the API token wins because it is the modern,
scoped credential type.

## See also

Other authentication:
[`cf_api_key()`](https://drmowinckels.github.io/cloudflarer/reference/cf_api_key.md),
[`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md),
[`cf_has_auth()`](https://drmowinckels.github.io/cloudflarer/reference/cf_has_auth.md),
[`cf_sitrep()`](https://drmowinckels.github.io/cloudflarer/reference/cf_sitrep.md),
[`cf_token()`](https://drmowinckels.github.io/cloudflarer/reference/cf_token.md),
[`cf_verify()`](https://drmowinckels.github.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
cf_auth_mode()
#> [1] NA
```
