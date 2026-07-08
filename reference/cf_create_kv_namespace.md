# Create a Workers KV namespace

Create a Workers KV namespace

## Usage

``` r
cf_create_kv_namespace(
  account_id,
  title,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- title:

  Character. Human-readable namespace name.

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

A named list describing the created namespace.

## See also

Other workers:
[`cf_delete_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_namespace.md),
[`cf_delete_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_value.md),
[`cf_delete_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_values.md),
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_get_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_value.md),
[`cf_get_workers_script()`](http://drmowinckels.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_keys()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_keys.md),
[`cf_list_kv_namespaces()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_put_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_value.md),
[`cf_put_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_values.md),
[`cf_rename_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_rename_kv_namespace.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
cf_create_kv_namespace("abc123", "sessions")
#> $id
#> [1] "ns-new"
#> 
#> $title
#> [1] "sessions"
#> 
#> $supports_url_encoding
#> [1] TRUE
#> 
```
