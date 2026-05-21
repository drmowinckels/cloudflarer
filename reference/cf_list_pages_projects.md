# List Cloudflare Pages projects

Returns the Pages projects in the supplied account. The Pages projects
endpoint does not accept pagination parameters (unlike most other
Cloudflare list endpoints) and returns every project in a single call.

## Usage

``` r
cf_list_pages_projects(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- account_id:

  Character. Cloudflare account identifier.

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md).
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

A data.frame of Pages projects (or list when `as_df = FALSE`).

## See also

Other pages:
[`cf_get_pages_project()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_pages_project.md),
[`cf_list_pages_deployments()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_deployments.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_pages_projects("abc123")
} # }
```
