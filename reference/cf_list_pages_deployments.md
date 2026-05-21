# List deployments for a Pages project

Returns the recent deployments (build history) for a Pages project,
ordered by date descending.

## Usage

``` r
cf_list_pages_deployments(
  account_id,
  project_name,
  per_page = 25,
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

- project_name:

  Character. Pages project name.

- per_page, max_pages:

  Pagination controls.

- as_df:

  Logical. When `TRUE` (the default), returns a data.frame via
  [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md).

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

A data.frame of deployment records (or list when `as_df = FALSE`).

## See also

Other pages:
[`cf_get_pages_project()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_pages_project.md),
[`cf_list_pages_projects()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_projects.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_list_pages_deployments("abc123", "my-site")
} # }
```
