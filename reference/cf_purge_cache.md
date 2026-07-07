# Purge zone cache

Tells Cloudflare to drop cached content for a zone. Pass one of the
targeted-purge arguments to scope the purge, or set
`purge_everything = TRUE` to wipe the entire zone cache.

## Usage

``` r
cf_purge_cache(
  zone_id,
  files = NULL,
  hosts = NULL,
  prefixes = NULL,
  tags = NULL,
  purge_everything = FALSE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- files:

  Optional character vector of URLs (or list of
  `list(url = ..., headers = ...)` for advanced purges with custom
  request headers).

- hosts:

  Optional character vector of hostnames whose cached content should be
  invalidated.

- prefixes:

  Optional character vector of URL prefixes (without scheme) to
  invalidate, e.g. `"example.com/blog"`.

- tags:

  Optional character vector of cache tags (Enterprise plan).

- purge_everything:

  Logical. When `TRUE`, ignores the targeted arguments and purges the
  entire zone cache.

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

A named list with the purge job `id`.

## Details

Targeted purges are strictly preferred to wipes because cache wipes can
briefly increase origin load. Cloudflare also rate limits the wipe
endpoint per zone.

## Examples

``` r
cf_purge_cache("abc123", files = c(
  "https://example.com/index.html",
  "https://example.com/style.css"
))
#> $id
#> [1] "purge-job-1"
#> 

cf_purge_cache("abc123", purge_everything = TRUE)
#> $id
#> [1] "purge-job-2"
#> 
```
