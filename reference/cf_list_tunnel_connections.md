# List active connections for a Cloudflare Tunnel

Returns the currently-connected `cloudflared` instances for the tunnel.

## Usage

``` r
cf_list_tunnel_connections(
  account_id,
  tunnel_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- tunnel_id:

  Character. Tunnel identifier.

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

A data.frame of connection records (or list when `as_df = FALSE`).

## See also

Other tunnels:
[`cf_get_tunnel()`](http://drmowinckels.io/cloudflarer/reference/cf_get_tunnel.md),
[`cf_list_tunnels()`](http://drmowinckels.io/cloudflarer/reference/cf_list_tunnels.md)

## Examples

``` r
cf_list_tunnel_connections("abc123", "tunnel-1")
#> # A tibble: 2 × 3
#>   id     colo_name is_pending_reconnect
#> * <chr>  <chr>     <lgl>               
#> 1 conn-1 AMS       FALSE               
#> 2 conn-2 CDG       FALSE               
```
