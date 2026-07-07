# Check whether any Cloudflare credentials are configured

Returns `TRUE` when
[`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md)
returns a non-`NA` value. Useful in examples, vignettes, and conditional
test code.

## Usage

``` r
cf_has_auth()
```

## Value

Logical scalar.

## See also

Other authentication:
[`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md),
[`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md),
[`cf_email()`](http://drmowinckels.io/cloudflarer/reference/cf_email.md),
[`cf_sitrep()`](http://drmowinckels.io/cloudflarer/reference/cf_sitrep.md),
[`cf_token()`](http://drmowinckels.io/cloudflarer/reference/cf_token.md),
[`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md)

## Examples

``` r
cf_has_auth()
#> [1] TRUE
```
