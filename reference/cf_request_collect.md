# Collect every page of a paginated endpoint

Iterates through all pages of a Cloudflare list endpoint and
concatenates the `result` arrays into a single list.

## Usage

``` r
cf_request_collect(
  endpoint,
  query = NULL,
  per_page = 50,
  max_pages = Inf,
  token = NULL,
  email = NULL,
  api_key = NULL,
  ...
)
```

## Arguments

- endpoint:

  Character. Path relative to the API base URL, without a leading slash
  (for example `"zones"` or `"zones/abc123/dns_records"`). May also
  include path segments joined by `"/"`.

- query:

  Optional named list of query parameters. `NULL` values are dropped.

- per_page:

  Integer page size. Cloudflare caps most endpoints at 50; some allow up
  to 1000.

- max_pages:

  Optional integer. Stop after collecting this many pages. Useful for
  exploratory calls against large accounts. `Inf` (the default) collects
  everything.

- token:

  Character. An API token. If `NULL` (the default), the value of
  `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.

- email:

  Character. Account email. If `NULL` (the default), reads from the
  `CLOUDFLARE_EMAIL` environment variable.

- api_key:

  Character. The Global API Key. If `NULL` (the default), reads from the
  `CLOUDFLARE_API_KEY` environment variable.

- ...:

  Additional arguments passed to
  [`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html).

## Value

A list of records.

## See also

Other requests:
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_request_collect("zones", per_page = 50)
} # }
```
