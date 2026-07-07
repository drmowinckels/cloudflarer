#' Cloudflare API base URL
#'
#' The base URL used for all requests. Defaults to the production
#' endpoint and can be overridden through the
#' `CLOUDFLARE_API_URL` environment variable, which is useful for
#' tests against a mock server.
#'
#' @return Character scalar.
#' @keywords internal
#' @noRd
cf_base_url <- function() {
  Sys.getenv(
    "CLOUDFLARE_API_URL",
    unset = "https://api.cloudflare.com/client/v4"
  )
}

#' User agent string sent with every request
#' @keywords internal
#' @noRd
cf_user_agent <- function() {
  sprintf(
    "cloudflarer/%s (R %s; +https://github.com/drmowinckels/cloudflarer)",
    utils::packageVersion("cloudflarer"),
    paste(R.version$major, R.version$minor, sep = ".")
  )
}

#' Build an authenticated Cloudflare request
#'
#' Internal helper that returns a base `httr2` request with the API
#' URL, credentials, headers, and error handler attached. All
#' endpoint helpers in the package build on top of this.
#'
#' Credential selection: an explicit `token` argument always wins;
#' otherwise explicit `email` + `api_key` win; otherwise the value
#' of [cf_auth_mode()] decides which environment-variable pair to
#' use.
#'
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return An `httr2_request`.
#' @keywords internal
#' @noRd
cf_req <- function(token = NULL, email = NULL, api_key = NULL) {
  req <- httr2::request(cf_base_url()) |>
    httr2::req_user_agent(cf_user_agent()) |>
    httr2::req_headers(Accept = "application/json") |>
    httr2::req_error(is_error = function(resp) FALSE)
  cf_req_auth(req, token = token, email = email, api_key = api_key)
}

#' Attach credentials to a request
#'
#' Dispatches on the available credentials in the order documented
#' for `cf_req()`.
#' @keywords internal
#' @noRd
cf_req_auth <- function(req, token = NULL, email = NULL, api_key = NULL) {
  if (!is.null(token)) {
    return(httr2::req_auth_bearer_token(req, token))
  }
  if (!is.null(email) || !is.null(api_key)) {
    return(httr2::req_headers(
      req,
      `X-Auth-Email` = cf_email(email),
      `X-Auth-Key` = cf_api_key(api_key)
    ))
  }
  mode <- cf_auth_mode()
  if (is.na(mode)) {
    cli::cli_abort(c(
      "No Cloudflare credentials found.",
      i = paste(
        "Set {.envvar CLOUDFLARE_API_TOKEN}, or both",
        "{.envvar CLOUDFLARE_EMAIL} and {.envvar CLOUDFLARE_API_KEY}."
      ),
      i = "See {.code vignette(\"authentication\", package = \"cloudflarer\")}."
    ))
  }
  if (mode == "token") {
    return(httr2::req_auth_bearer_token(req, cf_token()))
  }
  httr2::req_headers(
    req,
    `X-Auth-Email` = cf_email(),
    `X-Auth-Key` = cf_api_key()
  )
}

#' Build an authenticated request for a Cloudflare endpoint
#'
#' Returns an `httr2` request with credentials, headers, and the
#' endpoint path attached, ready to be piped through `httr2` request
#' modifiers ([httr2::req_method()], [httr2::req_url_query()],
#' [httr2::req_body_json()]) and performed with
#' [httr2::req_perform()]. Pair the performed response with
#' [cf_resp()] to unwrap the standard Cloudflare envelope, or pipe
#' the request into [cf_collect()] to walk a paginated list
#' endpoint. This is the base that every dedicated wrapper in the
#' package builds on, and the entry point for calling any endpoint
#' that does not yet have one.
#'
#' @param endpoint Path relative to the API base URL, without a
#'   leading slash. Either a single string (for example `"zones"` or
#'   `"zones/abc123/dns_records"`) or a character vector of segments
#'   (`c("zones", zone_id, "dns_records")`); each segment is appended
#'   to the URL path via [httr2::req_url_path_append()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return An `httr2_request`.
#'
#' @export
#' @family requests
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_request",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_request("user/tokens/verify") |>
#'   httr2::req_perform() |>
#'   cf_resp()
#'
#' cf_request(c("zones", "abc123", "dns_records")) |>
#'   httr2::req_method("POST") |>
#'   httr2::req_body_json(
#'     list(type = "A", name = "example.com", content = "192.0.2.1")
#'   ) |>
#'   httr2::req_perform() |>
#'   cf_resp()
#'
#' cf_request("zones") |>
#'   httr2::req_url_query(status = "active") |>
#'   cf_collect(per_page = 50)
#' \dontshow{vcr::eject_cassette()}
cf_request <- function(endpoint, token = NULL, email = NULL, api_key = NULL) {
  cf_req(token = token, email = email, api_key = api_key) |>
    cf_req_path(endpoint)
}

#' Unwrap the result from a Cloudflare response
#'
#' Validates the standard Cloudflare envelope on a performed
#' response and returns its `result` payload. Typically the terminal
#' step of a request pipeline built with [cf_request()] and
#' [httr2::req_perform()].
#'
#' The Cloudflare API wraps every response in an envelope with
#' `success`, `errors`, `messages`, `result`, and (for paginated
#' endpoints) `result_info`. API-level failures -- both HTTP error
#' statuses and envelope errors (HTTP 200 with `success: false`) --
#' raise a classed condition you can catch with
#' `tryCatch(..., cloudflarer_error = ...)`. Transport-level failures
#' that never reach the API (DNS resolution, connection refused,
#' timeout) surface as the underlying `httr2` error instead.
#'
#' @param resp An `httr2_response`, typically from
#'   `cf_request(...) |> httr2::req_perform()`.
#'
#' @return The parsed `result` element from the response. For
#'   single-resource endpoints this is a named list; for collection
#'   endpoints it is a list of records.
#'
#' @export
#' @family requests
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_resp", package = "cloudflarer")
#' }
#' cf_request("user") |>
#'   httr2::req_perform() |>
#'   cf_resp()
#' \dontshow{vcr::eject_cassette()}
cf_resp <- function(resp) {
  cf_resp_envelope(resp)[["result"]]
}

#' Collect every page of a paginated endpoint
#'
#' Given a request built with [cf_request()] (optionally with query
#' filters piped on), walks every page of a Cloudflare list endpoint
#' and concatenates the `result` arrays into a single list. Page
#' size and paging cursor are added as query parameters on each
#' request.
#'
#' @param req An `httr2_request` from [cf_request()].
#' @param per_page Integer page size. Cloudflare caps most endpoints
#'   at 50; some allow up to 1000.
#' @param max_pages Optional integer. Stop after collecting this
#'   many pages. Useful for exploratory calls against large
#'   accounts. `Inf` (the default) collects everything.
#' @param ... Additional arguments passed to [httr2::req_perform()].
#'
#' @return A list of records.
#' @export
#' @family requests
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_collect", package = "cloudflarer")
#' }
#' cf_request("zones") |> cf_collect(per_page = 50)
#' \dontshow{vcr::eject_cassette()}
cf_collect <- function(req, per_page = 50, max_pages = Inf, ...) {
  results <- list()
  page <- 1L
  repeat {
    env <- req |>
      httr2::req_url_query(per_page = per_page, page = page) |>
      httr2::req_perform(...) |>
      cf_resp_envelope()
    if (!is.null(env[["result"]])) {
      results <- c(results, env[["result"]])
    }
    total_pages <- env$result_info$total_pages %||% 1L
    if (page >= total_pages || page >= max_pages) {
      break
    }
    page <- page + 1L
  }
  results
}

#' Parse the standard Cloudflare envelope
#'
#' All requests in the package go through this function. It turns
#' both HTTP-level errors and Cloudflare envelope errors (HTTP 200
#' with `success: false`) into a single `cloudflarer_error`
#' condition.
#' @keywords internal
#' @noRd
cf_resp_envelope <- function(resp) {
  status <- httr2::resp_status(resp)

  if (!httr2::resp_has_body(resp)) {
    if (status < 400L) {
      return(list(success = TRUE, result = NULL))
    }
    cli::cli_abort(
      "Cloudflare API request failed with HTTP {status} and an empty body.",
      class = "cloudflarer_error",
      status_code = status
    )
  }

  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = FALSE),
    error = function(e) NULL
  )

  if (is.null(body)) {
    cli::cli_abort(
      c(
        "Cloudflare API returned a non-JSON response.",
        i = "HTTP status: {status}"
      ),
      class = "cloudflarer_error",
      status_code = status
    )
  }

  if (!isTRUE(body$success)) {
    cf_abort_envelope(body, resp)
  }
  body
}

#' Raise a classed error from a parsed envelope
#' @keywords internal
#' @noRd
cf_abort_envelope <- function(body, resp) {
  parts <- format_cf_errors(body$errors)
  cli::cli_abort(
    c("Cloudflare API request failed.", parts),
    class = "cloudflarer_error",
    status_code = httr2::resp_status(resp),
    errors = body$errors,
    messages = body$messages
  )
}

format_cf_errors <- function(errors) {
  if (!length(errors)) {
    return("No error details provided.")
  }
  vapply(errors, format_cf_error, character(1))
}

format_cf_error <- function(err) {
  base <- sprintf(
    "[%s] %s",
    err$code %||% "?",
    err$message %||% "Unknown error"
  )
  chain <- err$error_chain
  if (length(chain)) {
    chain_msgs <- vapply(
      chain,
      function(x) sprintf("  - [%s] %s", x$code %||% "?", x$message %||% ""),
      character(1)
    )
    base <- paste(c(base, chain_msgs), collapse = "\n")
  }
  base
}

cf_req_path <- function(req, endpoint) {
  parts <- unlist(strsplit(endpoint, "/", fixed = TRUE), use.names = FALSE)
  parts <- parts[nzchar(parts)]
  if (!length(parts)) {
    return(req)
  }
  rlang::inject(httr2::req_url_path_append(req, !!!parts))
}

drop_nulls <- function(x) {
  if (!length(x)) {
    return(x)
  }
  x[!vapply(x, is.null, logical(1))]
}
