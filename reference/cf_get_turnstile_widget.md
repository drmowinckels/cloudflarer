# Get a single Turnstile widget

Get a single Turnstile widget

## Usage

``` r
cf_get_turnstile_widget(
  account_id,
  sitekey,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- sitekey:

  Character. Widget sitekey.

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

A named list describing the widget.

## See also

Other turnstile:
[`cf_create_turnstile_widget()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_turnstile_widget.md),
[`cf_delete_turnstile_widget()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_turnstile_widget.md),
[`cf_list_turnstile_widgets()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_turnstile_widgets.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_turnstile_widget("abc123", "0x4AAA...")
} # }
```
