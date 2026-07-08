<!-- README.md is generated from README.Rmd. Please edit that file -->

# cloudflarer <a href="http://drmowinckels.io/cloudflarer/"><img src="man/figures/logo.png" align="right" height="138" alt="cloudflarer website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/drmowinckels/cloudflarer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/drmowinckels/cloudflarer/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/drmowinckels/cloudflarer/graph/badge.svg)](https://app.codecov.io/gh/drmowinckels/cloudflarer)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/cloudflarer)](https://CRAN.R-project.org/package=cloudflarer)

<!-- badges: end -->

cloudflarer is an R wrapper around the [Cloudflare REST API
(v4)](https://developers.cloudflare.com/api/). It provides authenticated
request helpers, response unwrapping, paginated list collectors, and a
generic
[`cf_request()`](https://drmowinckels.io/cloudflarer/reference/cf_request.html)
function so you can call any endpoint, including ones the package does
not wrap yet.

## Installation

Install the released version from CRAN:

```r
install.packages("cloudflarer")
```

Or install the development version from GitHub:

```r
# install.packages("pak")
pak::pak("drmowinckels/cloudflarer")
```

## Authentication

cloudflarer supports both Cloudflare credential schemes:

- **API token** (recommended) – created at
  <https://dash.cloudflare.com/profile/api-tokens>, scoped to the
  resources and verbs your script needs.
- **Global API Key** (legacy) – the unscoped account-wide key, paired
  with the account email.

Set whichever you prefer in `~/.Renviron`:

    # API token (recommended)
    CLOUDFLARE_API_TOKEN=your-token-here

    # OR Global API Key (legacy)
    CLOUDFLARE_EMAIL=you@example.com
    CLOUDFLARE_API_KEY=your-global-api-key

Restart R and check the connection:

```r
library(cloudflarer)
cf_sitrep()
```

See `vignette("authentication", package = "cloudflarer")` for the full
walkthrough.

## Usage

```r
library(cloudflarer)

cf_user()
cf_list_accounts()
cf_list_zones()
cf_list_dns_records(zone_id = "abc123")
```

### Calling endpoints that are not wrapped yet

Every endpoint in the [Cloudflare API
reference](https://developers.cloudflare.com/api/) is reachable through
the generic `cf_request()` helper, which builds an authenticated
request. Pipe it through the `httr2` verbs you need, perform it, and
unwrap the `{success, errors, result, ...}` envelope with `cf_resp()`
(which raises a classed `cloudflarer_error` on failure).

```r
cf_request("user/tokens/verify") |>
  httr2::req_perform() |>
  cf_resp()

cf_request("zones/abc123/dns_records") |>
  httr2::req_method("POST") |>
  httr2::req_body_json(list(
    type    = "A",
    name    = "www.example.com",
    content = "192.0.2.1",
    ttl     = 1,
    proxied = TRUE
  )) |>
  httr2::req_perform() |>
  cf_resp()
```

For paginated list endpoints, pipe the request into `cf_collect()`:

```r
cf_request("accounts") |> cf_collect(per_page = 50)
```

## Code of Conduct

Please note that the cloudflarer project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
