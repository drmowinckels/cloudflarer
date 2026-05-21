# Get a single Cloudflare Pages project

Get a single Cloudflare Pages project

## Usage

``` r
cf_get_pages_project(
  account_id,
  project_name,
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

A named list describing the project, including build config, domains,
and the latest deployment.

## See also

Other pages:
[`cf_list_pages_deployments()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_deployments.md),
[`cf_list_pages_projects()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_projects.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_get_pages_project("abc123", "my-site")
} # }
```
