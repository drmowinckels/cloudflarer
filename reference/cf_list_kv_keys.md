# List the keys in a Workers KV namespace

Walks the namespace's cursor-paginated `keys` endpoint and concatenates
every page into a single result. Unlike the offset-paginated list
endpoints wrapped by
[`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md),
Cloudflare paginates KV keys with an opaque cursor, so this wrapper
keeps its own loop instead.

## Usage

``` r
cf_list_kv_keys(
  account_id,
  namespace_id,
  prefix = NULL,
  limit = 1000,
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

- namespace_id:

  Character. KV namespace identifier.

- prefix:

  Optional character. Restrict results to keys starting with this
  prefix.

- limit:

  Integer. Page size, between 10 and 1000.

- max_pages:

  Optional integer. Stop after collecting this many pages. `Inf` (the
  default) collects every key.

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md).
  Set to `FALSE` for the raw nested list.

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

A data.frame of key records (or list when `as_df = FALSE`), each with
`name`, `expiration`, and `metadata` (when set).

## See also

Other workers:
[`cf_create_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_create_kv_namespace.md),
[`cf_delete_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_namespace.md),
[`cf_delete_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_value.md),
[`cf_delete_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_kv_values.md),
[`cf_get_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_namespace.md),
[`cf_get_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_get_kv_value.md),
[`cf_get_workers_script()`](http://drmowinckels.io/cloudflarer/reference/cf_get_workers_script.md),
[`cf_list_kv_namespaces()`](http://drmowinckels.io/cloudflarer/reference/cf_list_kv_namespaces.md),
[`cf_list_workers_scripts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_workers_scripts.md),
[`cf_put_kv_value()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_value.md),
[`cf_put_kv_values()`](http://drmowinckels.io/cloudflarer/reference/cf_put_kv_values.md),
[`cf_rename_kv_namespace()`](http://drmowinckels.io/cloudflarer/reference/cf_rename_kv_namespace.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md)

## Examples

``` r
cf_list_kv_keys("abc123", "ns-1")
#> # A tibble: 2 × 2
#>   name     expiration
#> * <chr>    <lgl>     
#> 1 greeting NA        
#> 2 farewell NA        
```
