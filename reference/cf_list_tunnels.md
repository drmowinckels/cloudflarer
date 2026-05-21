# List Cloudflare Tunnels

Returns the cloudflared tunnels (Zero Trust) configured in the supplied
account.

## Usage

``` r
cf_list_tunnels(
  account_id,
  is_deleted = FALSE,
  per_page = 50,
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

- is_deleted:

  Logical. When `TRUE`, include deleted tunnels.

- per_page, max_pages:

  Pagination controls, see
  [`cf_request_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_request_collect.md).

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).

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

A data.frame of tunnel records (or list when `as_df = FALSE`).

## See also

Other tunnels:
[`cf_get_tunnel()`](http://drmowinckels.io/cloudflarer/reference/cf_get_tunnel.md),
[`cf_list_tunnel_connections()`](http://drmowinckels.io/cloudflarer/reference/cf_list_tunnel_connections.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_tunnels("abc123")
} # }
```
