# Write a value to a Workers KV namespace

Write a value to a Workers KV namespace

## Usage

``` r
cf_put_kv_value(
  account_id,
  namespace_id,
  key_name,
  value,
  expiration = NULL,
  expiration_ttl = NULL,
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

- key_name:

  Character. Key to read.

- value:

  Character string or raw vector. The value to store.

- expiration:

  Optional integer. Absolute expiration time as a Unix timestamp
  (seconds).

- expiration_ttl:

  Optional integer. Expiration in seconds from now (minimum 60).

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

`TRUE`, invisibly, on success.

## See also

Other workers:
[`cf_create_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_create_kv_namespace.md),
[`cf_delete_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_namespace.md),
[`cf_delete_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_value.md),
[`cf_delete_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_values.md),
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_get_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_value.md),
[`cf_get_workers_script()`](http://drmowinckels.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_keys()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_keys.md),
[`cf_list_kv_namespaces()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_put_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_values.md),
[`cf_rename_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_rename_kv_namespace.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
cf_put_kv_value("abc123", "ns-1", "greeting", "hello world")
```
