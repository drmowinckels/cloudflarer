# Unwrap the result from a Cloudflare response

Validates the standard Cloudflare envelope on a performed response and
returns its `result` payload. Typically the terminal step of a request
pipeline built with
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)
and
[`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html).

## Usage

``` r
cf_resp(resp)
```

## Arguments

- resp:

  An `httr2_response`, typically from
  `cf_request(...) |> httr2::req_perform()`.

## Value

The parsed `result` element from the response. For single-resource
endpoints this is a named list; for collection endpoints it is a list of
records.

## Details

The Cloudflare API wraps every response in an envelope with `success`,
`errors`, `messages`, `result`, and (for paginated endpoints)
`result_info`. API-level failures – both HTTP error statuses and
envelope errors (HTTP 200 with `success: false`) – raise a classed
condition you can catch with `tryCatch(..., cloudflarer_error = ...)`.
Transport-level failures that never reach the API (DNS resolution,
connection refused, timeout) surface as the underlying `httr2` error
instead.

## See also

Other requests:
[`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md),
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)

## Examples

``` r
cf_request("user") |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "user-1"
#> 
#> $email
#> [1] "you@example.com"
#> 
```
