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

# Intercept httr2::req_perform so a wrapper builds a real request but
# performs nothing. Returns an environment whose `$req` holds the
# captured httr2 request; the mocked perform returns a canned success
# envelope so cf_resp()/cf_collect() unwrap without hitting the network.
local_captured_request <- function(
  body = '{"success":true,"result":[],"result_info":{"total_pages":1}}',
  envir = parent.frame()
) {
  captured <- new.env(parent = emptyenv())
  testthat::local_mocked_bindings(
    req_perform = function(req, ...) {
      captured$req <- req
      httr2::response(
        status_code = 200,
        headers = list("content-type" = "application/json"),
        body = charToRaw(body)
      )
    },
    .package = "httr2",
    .env = envir
  )
  captured
}
