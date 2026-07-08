# Read a value from a Workers KV namespace

Unlike most Cloudflare endpoints, this one returns the raw stored value
rather than a JSON envelope, so the result is not passed through
[`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md).

## Usage

``` r
cf_get_kv_value(
  account_id,
  namespace_id,
  key_name,
  as = c("text", "raw"),
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

- as:

  Character. `"text"` (the default) returns the value as a string via
  [`httr2::resp_body_string()`](https://httr2.r-lib.org/reference/resp_body_raw.html);
  `"raw"` returns the raw bytes via
  [`httr2::resp_body_raw()`](https://httr2.r-lib.org/reference/resp_body_raw.html),
  useful for binary values.

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

A character string, or a raw vector when `as = "raw"`.

## See also

Other workers:
[`cf_create_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_create_kv_namespace.md),
[`cf_delete_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_namespace.md),
[`cf_delete_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_value.md),
[`cf_delete_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_values.md),
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
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
cf_get_kv_value("abc123", "ns-1", "greeting")
#> [1] "hello world"
```
