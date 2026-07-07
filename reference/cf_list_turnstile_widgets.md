# List Turnstile widgets

Lists the Turnstile (Cloudflare's CAPTCHA replacement) widgets
configured in an account.

## Usage

``` r
cf_list_turnstile_widgets(
  account_id,
  per_page = 25,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- per_page, max_pages:

  Pagination controls, see
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
  Set to `FALSE` for the raw nested list.

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

A data.frame of widget records (or list when `as_df = FALSE`).

## See also

Other turnstile:
[`cf_create_turnstile_widget()`](http://drmowinckels.io/cloudflarer/reference/cf_create_turnstile_widget.md),
[`cf_delete_turnstile_widget()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_turnstile_widget.md),
[`cf_get_turnstile_widget()`](http://drmowinckels.io/cloudflarer/reference/cf_get_turnstile_widget.md)

## Examples

``` r
cf_list_turnstile_widgets("abc123")
#> # A tibble: 2 × 3
#>   sitekey     name         mode     
#> * <chr>       <chr>        <chr>    
#> 1 0x4AAAAAAA1 comment-form managed  
#> 2 0x4AAAAAAA2 signup-form  invisible
```
