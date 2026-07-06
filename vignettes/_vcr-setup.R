# Shared setup for the package vignettes: run every chunk offline against
# the synthetic vcr cassettes in vignettes/_vcr/. Sourced from each
# vignette's hidden setup chunk so the configuration lives in one place.
library(cloudflarer)

# A placeholder token so the request builders authenticate; vcr replays
# from the cassettes, so the value is never sent anywhere.
Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-vignette")

vcr::vcr_configure(
  dir = "_vcr",
  match_requests_on = c("method", "uri"),
  filter_request_headers = "Authorization"
)
# prefix = "" so a chunk's `cassette` option maps straight to _vcr/<name>.yml
vcr::setup_knitr(prefix = "")

knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
