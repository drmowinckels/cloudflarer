#' Detect which Cloudflare auth mode is configured
#'
#' Returns the credential type that the next request would use,
#' based on the current environment:
#'
#' * `"token"` -- `CLOUDFLARE_API_TOKEN` is set.
#' * `"key"` -- both `CLOUDFLARE_EMAIL` and `CLOUDFLARE_API_KEY` are set.
#' * `NA_character_` -- no usable credentials are available.
#'
#' When both are configured, the API token wins because it is the
#' modern, scoped credential type.
#'
#' @return A character scalar (`"token"`, `"key"`, or `NA_character_`).
#' @export
#' @family authentication
#' @examples
#' cf_auth_mode()
cf_auth_mode <- function() {
  if (is_nonempty_string(Sys.getenv("CLOUDFLARE_API_TOKEN", unset = ""))) {
    return("token")
  }
  if (
    is_nonempty_string(Sys.getenv("CLOUDFLARE_EMAIL", unset = "")) &&
      is_nonempty_string(Sys.getenv("CLOUDFLARE_API_KEY", unset = ""))
  ) {
    return("key")
  }
  NA_character_
}

#' Check whether any Cloudflare credentials are configured
#'
#' Returns `TRUE` when [cf_auth_mode()] returns a non-`NA` value.
#' Useful in examples, vignettes, and conditional test code.
#'
#' @return Logical scalar.
#' @export
#' @family authentication
#' @examples
#' cf_has_auth()
cf_has_auth <- function() {
  !is.na(cf_auth_mode())
}

#' Cloudflare API token
#'
#' Returns the modern Cloudflare API token. By default reads from
#' the `CLOUDFLARE_API_TOKEN` environment variable. See
#' `vignette("authentication", package = "cloudflarer")` for guidance
#' on creating a token and storing it safely.
#'
#' @param token Character. An API token. If `NULL` (the default),
#'   the value of `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.
#'
#' @return A character scalar with the API token.
#' @export
#' @family authentication
#' @examplesIf requireNamespace("withr", quietly = TRUE)
#' withr::with_envvar(
#'   c(CLOUDFLARE_API_TOKEN = "cloudflarer-example"),
#'   cf_token()
#' )
cf_token <- function(token = NULL) {
  token <- token %||% Sys.getenv("CLOUDFLARE_API_TOKEN", unset = "")
  if (!is_nonempty_string(token)) {
    cli::cli_abort(c(
      "No Cloudflare API token found.",
      i = "Set the {.envvar CLOUDFLARE_API_TOKEN} environment variable.",
      i = "See {.code vignette(\"authentication\", package = \"cloudflarer\")}."
    ))
  }
  token
}

#' Cloudflare account email (legacy auth)
#'
#' Reads the account email used together with [cf_api_key()] for
#' Cloudflare's legacy Global API Key authentication. Defaults to
#' `Sys.getenv("CLOUDFLARE_EMAIL")`.
#'
#' @param email Character. Account email. If `NULL` (the default),
#'   reads from the `CLOUDFLARE_EMAIL` environment variable.
#'
#' @return A character scalar with the email address.
#' @export
#' @family authentication
#' @examplesIf requireNamespace("withr", quietly = TRUE)
#' withr::with_envvar(
#'   c(CLOUDFLARE_EMAIL = "you@example.com"),
#'   cf_email()
#' )
cf_email <- function(email = NULL) {
  email <- email %||% Sys.getenv("CLOUDFLARE_EMAIL", unset = "")
  if (!is_nonempty_string(email)) {
    cli::cli_abort(c(
      "No Cloudflare account email found.",
      i = "Set the {.envvar CLOUDFLARE_EMAIL} environment variable."
    ))
  }
  email
}

#' Cloudflare Global API Key (legacy auth)
#'
#' Reads the Global API Key used together with [cf_email()] for
#' Cloudflare's legacy authentication scheme. Prefer creating a
#' scoped API token instead; see [cf_token()].
#'
#' @param api_key Character. The Global API Key. If `NULL` (the
#'   default), reads from the `CLOUDFLARE_API_KEY` environment
#'   variable.
#'
#' @return A character scalar with the API key.
#' @export
#' @family authentication
#' @examplesIf requireNamespace("withr", quietly = TRUE)
#' withr::with_envvar(
#'   c(CLOUDFLARE_API_KEY = "cloudflarer-example-key"),
#'   cf_api_key()
#' )
cf_api_key <- function(api_key = NULL) {
  api_key <- api_key %||% Sys.getenv("CLOUDFLARE_API_KEY", unset = "")
  if (!is_nonempty_string(api_key)) {
    cli::cli_abort(c(
      "No Cloudflare Global API Key found.",
      i = "Set the {.envvar CLOUDFLARE_API_KEY} environment variable.",
      i = "Prefer a scoped API token via {.envvar CLOUDFLARE_API_TOKEN}."
    ))
  }
  api_key
}

#' Verify the active Cloudflare credential
#'
#' For token auth, calls `/user/tokens/verify` and returns the token
#' record. For Global API Key auth, calls `/user` and returns the
#' user record (the verify endpoint is token-only). Either way, a
#' successful return means the credential authenticates against the
#' API.
#'
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list. The shape depends on the auth mode.
#' @export
#' @family authentication
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_verify", package = "cloudflarer")
#' }
#' cf_verify()
#' \dontshow{vcr::eject_cassette()}
cf_verify <- function(token = NULL, email = NULL, api_key = NULL) {
  req <- if (!is.null(token)) {
    cf_request("user/tokens/verify", token = token)
  } else if (!is.null(email) || !is.null(api_key)) {
    cf_request("user", email = email, api_key = api_key)
  } else if (isTRUE(cf_auth_mode() == "token")) {
    cf_request("user/tokens/verify")
  } else {
    cf_request("user")
  }
  req |>
    httr2::req_perform() |>
    cf_resp()
}

#' @rdname cf_verify
#' @export
cf_token_verify <- function(token = NULL) {
  cf_request("user/tokens/verify", token = token) |>
    httr2::req_perform() |>
    cf_resp()
}

is_nonempty_string <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
}
