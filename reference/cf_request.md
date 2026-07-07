# Build an authenticated request for a Cloudflare endpoint

Returns an `httr2` request with credentials, headers, and the endpoint
path attached, ready to be piped through `httr2` request modifiers
([`httr2::req_method()`](https://httr2.r-lib.org/reference/req_method.html),
[`httr2::req_url_query()`](https://httr2.r-lib.org/reference/req_url.html),
[`httr2::req_body_json()`](https://httr2.r-lib.org/reference/req_body.html))
and performed with
[`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html).
Pair the performed response with
[`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md)
to unwrap the standard Cloudflare envelope, or pipe the request into
[`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md)
to walk a paginated list endpoint. This is the base that every dedicated
wrapper in the package builds on, and the entry point for calling any
endpoint that does not yet have one.

## Usage

``` r
cf_request(endpoint, token = NULL, email = NULL, api_key = NULL)
```

## Arguments

- endpoint:

  Path relative to the API base URL, without a leading slash. Either a
  single string (for example `"zones"` or `"zones/abc123/dns_records"`)
  or a character vector of segments
  (`c("zones", zone_id, "dns_records")`); each segment is appended to
  the URL path via
  [`httr2::req_url_path_append()`](https://httr2.r-lib.org/reference/req_url.html).

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

An `httr2_request`.

## See also

Other requests:
[`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md),
[`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md)

## Examples

``` r
cf_request("user/tokens/verify") |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "tok-1"
#> 
#> $status
#> [1] "active"
#> 

cf_request(c("zones", "abc123", "dns_records")) |>
  httr2::req_method("POST") |>
  httr2::req_body_json(
    list(type = "A", name = "example.com", content = "192.0.2.1")
  ) |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "rec-new"
#> 
#> $type
#> [1] "A"
#> 
#> $name
#> [1] "example.com"
#> 
#> $content
#> [1] "192.0.2.1"
#> 

cf_request("zones") |>
  httr2::req_url_query(status = "active") |>
  cf_collect(per_page = 50)
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
