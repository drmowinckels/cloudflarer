# Create a Turnstile widget

Create a Turnstile widget

## Usage

``` r
cf_create_turnstile_widget(
  account_id,
  name,
  domains,
  mode = c("managed", "non-interactive", "invisible"),
  bot_fight_mode = FALSE,
  region = "world",
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- name:

  Character. Human-readable widget name.

- domains:

  Character vector of domains where the widget will be embedded.

- mode:

  Character. Visibility mode: `"managed"` (Cloudflare decides),
  `"non-interactive"` (no user interaction), or `"invisible"`.

- bot_fight_mode:

  Logical. Enable Bot Fight Mode integration.

- region:

  Character. Where Turnstile runs from. `"world"` (default) or
  `"china"`.

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

A named list with the created widget, including its `sitekey` and
`secret` (only shown once).

## See also

Other turnstile:
[`cf_delete_turnstile_widget()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_turnstile_widget.md),
[`cf_get_turnstile_widget()`](http://drmowinckels.io/cloudflarer/reference/cf_get_turnstile_widget.md),
[`cf_list_turnstile_widgets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_turnstile_widgets.md)

## Examples

``` r
cf_create_turnstile_widget(
  "abc123",
  name = "comment-form",
  domains = c("example.com", "www.example.com"),
  mode = "managed"
)
#> $sitekey
#> [1] "0x4AAA..."
#> 
#> $secret
#> [1] "0x4BBB..."
#> 
#> $name
#> [1] "comment-form"
#> 
#> $mode
#> [1] "managed"
#> 
#> $domains
#> $domains[[1]]
#> [1] "example.com"
#> 
#> $domains[[2]]
#> [1] "www.example.com"
#> 
#> 
```
