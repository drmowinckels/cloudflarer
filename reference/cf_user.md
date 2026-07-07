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
cf_user()
#> $id
#> [1] "7c5dae5552338874e5053f2534d2767a"
#> 
#> $email
#> [1] "user@example.com"
#> 
#> $first_name
#> [1] "Ada"
#> 
#> $last_name
#> [1] "Lovelace"
#> 
#> $telephone
#> NULL
#> 
#> $country
#> [1] "GB"
#> 
#> $organizations
#> list()
#> 
```
