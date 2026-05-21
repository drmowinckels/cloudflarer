# Get a single Workers KV namespace

Get a single Workers KV namespace

## Usage

``` r
cf_get_kv_namespace(
  account_id,
  namespace_id,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- namespace_id:

  Character. KV namespace identifier.

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

A named list describing the namespace.

## See also

Other workers:
[`cf_get_workers_script()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_namespaces()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_kv_namespace("abc123", "ns-1")
} # }
```
