# Write multiple key-value pairs to a Workers KV namespace

Write multiple key-value pairs to a Workers KV namespace

## Usage

``` r
cf_put_kv_values(
  account_id,
  namespace_id,
  values,
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

- values:

  A list of entries, each a named list with a `key` and `value` element,
  and optionally `expiration`, `expiration_ttl`, `metadata`, or `base64`
  (see the [Cloudflare API docs](https://developers.cloudflare.com/api/)
  for the bulk write endpoint). Up to 10,000 entries per call.

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

A named list with `successful_key_count` and `unsuccessful_keys`.

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
[`cf_put_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_value.md),
[`cf_rename_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_rename_kv_namespace.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
cf_put_kv_values(
  "abc123",
  "ns-1",
  list(
    list(key = "greeting", value = "hello"),
    list(key = "farewell", value = "bye", expiration_ttl = 3600)
  )
)
#> $successful_key_count
#> [1] 2
#> 
#> $unsuccessful_keys
#> list()
#> 
```
