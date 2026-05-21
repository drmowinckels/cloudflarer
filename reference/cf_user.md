# Get the authenticated user

Returns information about the user that owns the API token.

## Usage

``` r
cf_user(token = NULL)
```

## Arguments

- token:

  Character. An API token. If `NULL` (the default), the value of
  `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.

## Value

A named list of user fields, including `id`, `email`, `first_name`,
`last_name`, and `organizations`.

## Examples

``` r
if (FALSE) { # \dontrun{
cf_user()
} # }
```
