# Cloudflare situation report

Prints a short summary of the package version, which auth mode is
configured
([`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md)),
and whether the configured credentials successfully authenticate against
the Cloudflare API. Use this as a first stop when debugging
configuration issues.

## Usage

``` r
cf_sitrep()
```

## Value

Invisibly, a list with the diagnostic results.

## See also

Other authentication:
[`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md),
[`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_email()`](http://drmowinckels.io/cloudflarer/reference/cf_email.md),
[`cf_has_auth()`](http://drmowinckels.io/cloudflarer/reference/cf_has_auth.md),
[`cf_token()`](http://drmowinckels.io/cloudflarer/reference/cf_token.md),
[`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
cf_sitrep()
#> 
#> ── cloudflarer sitrep ──────────────────────────────────────────────────────────
#> ℹ Package version: 0.0.0.9000
#> ✖ No Cloudflare credentials found in the environment.
#> ℹ Set `CLOUDFLARE_API_TOKEN`, or both `CLOUDFLARE_EMAIL` and `CLOUDFLARE_API_KEY`.
```
