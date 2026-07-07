# Collect every page of a paginated endpoint

Given a request built with
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)
(optionally with query filters piped on), walks every page of a
Cloudflare list endpoint and concatenates the `result` arrays into a
single list. Page size and paging cursor are added as query parameters
on each request.

## Usage

``` r
cf_collect(req, per_page = 50, max_pages = Inf, ...)
```

## Arguments

- req:

  An `httr2_request` from
  [`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md).

- per_page:

  Integer page size. Cloudflare caps most endpoints at 50; some allow up
  to 1000.

- max_pages:

  Optional integer. Stop after collecting this many pages. Useful for
  exploratory calls against large accounts. `Inf` (the default) collects
  everything.

- ...:

  Additional arguments passed to
  [`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html).

## Value

A list of records.

## See also

Other requests:
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md),
[`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md)

## Examples

``` r
cf_request("zones") |> cf_collect(per_page = 50)
#> [[1]]
#> [[1]]$id
#> [1] "abc123"
#> 
#> [[1]]$name
#> [1] "example.com"
#> 
#> [[1]]$status
#> [1] "active"
#> 
#> 
```
