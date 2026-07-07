# Get metadata for a single Workers script

Returns the script's metadata (placement, bindings, etc.). To fetch the
actual source, use the API's `/workers/scripts/{name}/content` endpoint
via
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md).

## Usage

``` r
cf_get_workers_script(
  account_id,
  script_name,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- script_name:

  Character. Worker script name.

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

A named list with the script metadata.

## See also

Other workers:
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_list_kv_namespaces()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
cf_get_workers_script("abc123", "my-worker")
#> $id
#> [1] "my-worker"
#> 
#> $created_on
#> [1] "2026-01-01T00:00:00Z"
#> 
#> $usage_model
#> [1] "standard"
#> 
```
