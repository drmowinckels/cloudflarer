# Get a single Cloudflare Tunnel

Get a single Cloudflare Tunnel

## Usage

``` r
cf_get_tunnel(
  account_id,
  tunnel_id,
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

A named list describing the tunnel.

## See also

Other tunnels:
[`cf_list_tunnel_connections()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_tunnel_connections.md),
[`cf_list_tunnels()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_tunnels.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_tunnel("abc123", "tunnel-1")
} # }
```
