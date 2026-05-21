# Perform a generic Cloudflare API request

Low-level wrapper that builds an authenticated request, performs it,
validates the standard Cloudflare response envelope, and returns the
`result` payload. Use this to call any endpoint that does not yet have a
dedicated wrapper in the package.

## Usage

``` r
cf_request(
  endpoint,
  method = "GET",
  query = NULL,
  body = NULL,
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

- method:

  HTTP method as a character string. Defaults to `"GET"`.

- query:

  Optional named list of query parameters. `NULL` values are dropped.

- body:

  Optional list. When supplied, the request is sent with
  `Content-Type: application/json`.

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

The parsed `result` element from the response. For collection endpoints
this is typically a list of records; for single-resource endpoints it is
a single named list.

## Details

The Cloudflare API wraps every response in an envelope with `success`,
`errors`, `messages`, `result`, and (for paginated endpoints)
`result_info`. `cf_request()` extracts `result`; errors raise a classed
condition you can catch with
`tryCatch(cf_request(...), cloudflarer_error = ...)`.

## See also

Other requests:
[`cf_request_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_request_collect.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_request("user/tokens/verify")
cf_request("zones", query = list(per_page = 5))
cf_request(
  "zones/abc123/dns_records",
  method = "POST",
  body = list(type = "A", name = "example.com", content = "1.2.3.4")
)
} # }
```
