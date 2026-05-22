library("vcr")
library("httr2")
library("withr")

invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("_vcr"),
  match_requests_on = c("method", "uri"),
  filter_request_headers = list(
    Authorization = "<<REDACTED_TOKEN>>",
    `X-Auth-Email` = "<<REDACTED_EMAIL>>",
    `X-Auth-Key` = "<<REDACTED_API_KEY>>"
  ),
  filter_sensitive_data = list(
    "<<REDACTED_TOKEN>>" = Sys.getenv("CLOUDFLARE_API_TOKEN"),
    "<<REDACTED_EMAIL>>" = Sys.getenv("CLOUDFLARE_EMAIL"),
    "<<REDACTED_API_KEY>>" = Sys.getenv("CLOUDFLARE_API_KEY")
  )
))

mock_token <- "test-token-for-vcr-cassettes"
mock_email <- "tester@example.com"
mock_api_key <- "test-api-key-for-vcr-cassettes"

local_mock_auth <- function(envir = parent.frame()) {
  withr::local_envvar(
    CLOUDFLARE_API_TOKEN = mock_token,
    CLOUDFLARE_EMAIL = "",
    CLOUDFLARE_API_KEY = "",
    .local_envir = envir
  )
}

local_mock_key_auth <- function(envir = parent.frame()) {
  withr::local_envvar(
    CLOUDFLARE_API_TOKEN = "",
    CLOUDFLARE_EMAIL = mock_email,
    CLOUDFLARE_API_KEY = mock_api_key,
    .local_envir = envir
  )
}

local_no_auth <- function(envir = parent.frame()) {
  withr::local_envvar(
    CLOUDFLARE_API_TOKEN = "",
    CLOUDFLARE_EMAIL = "",
    CLOUDFLARE_API_KEY = "",
    .local_envir = envir
  )
}

local_mock_if_no_auth <- function(envir = parent.frame()) {
  if (!cf_has_auth()) {
    withr::local_envvar(
      CLOUDFLARE_API_TOKEN = mock_token,
      .local_envir = envir
    )
  }
}
