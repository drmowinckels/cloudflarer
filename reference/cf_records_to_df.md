# Convert a list of Cloudflare records to a data.frame

Helper that takes a list of named records (typically the `result` array
from a Cloudflare REST endpoint) and returns a data.frame with one row
per record. Scalar fields become typed columns; vector- or object-valued
fields become list-columns.

## Usage

``` r
cf_records_to_df(records)
```

## Arguments

- records:

  A list of named lists with broadly consistent field names. Missing
  fields become `NA`.

## Value

A data.frame with one row per record and columns named by the union of
field names. Empty input returns an empty data.frame.

## Examples

``` r
records <- list(
  list(id = "a", name = "alpha", tags = c("x", "y")),
  list(id = "b", name = "beta",  tags = character(0))
)
cf_records_to_df(records)
#> # A tibble: 2 × 3
#>   id    name  tags     
#> * <chr> <chr> <I<list>>
#> 1 a     alpha <chr [2]>
#> 2 b     beta  <chr [0]>
```
