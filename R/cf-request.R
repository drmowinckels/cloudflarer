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

#' Perform a generic Cloudflare API request
#'
#' Low-level wrapper that builds an authenticated request, performs
#' it, validates the standard Cloudflare response envelope, and
#' returns the `result` payload. Use this to call any endpoint that
#' does not yet have a dedicated wrapper in the package.
#'
#' The Cloudflare API wraps every response in an envelope with
#' `success`, `errors`, `messages`, `result`, and (for paginated
#' endpoints) `result_info`. `cf_request()` extracts `result`;
#' errors raise a classed condition you can catch with
#' `tryCatch(cf_request(...), cloudflarer_error = ...)`.
#'
#' @param endpoint Character. Path relative to the API base URL,
#'   without a leading slash (for example `"zones"` or
#'   `"zones/abc123/dns_records"`). May also include path segments
#'   joined by `"/"`.
#' @param method HTTP method as a character string. Defaults to
#'   `"GET"`.
#' @param query Optional named list of query parameters.
#'   `NULL` values are dropped.
#' @param body Optional list. When supplied, the request is sent
#'   with `Content-Type: application/json`.
#' @param ... Additional arguments passed to [httr2::req_perform()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return The parsed `result` element from the response.
#'   For collection endpoints this is typically a list of records;
#'   for single-resource endpoints it is a single named list.
#'
#' @export
#' @family requests
#' @examples
#' \dontrun{
#' cf_request("user/tokens/verify")
#' cf_request("zones", query = list(per_page = 5))
#' cf_request(
#'   "zones/abc123/dns_records",
#'   method = "POST",
#'   body = list(type = "A", name = "example.com", content = "1.2.3.4")
#' )
#' }
cf_request <- function(
  endpoint,
  method = "GET",
  query = NULL,
  body = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL,
  ...
) {
  resp <- cf_perform(
    endpoint,
    method = method,
    query = query,
    body = body,
    token = token,
    email = email,
    api_key = api_key,
    ...
  )
  cf_resp_envelope(resp)$result
}

#' Collect every page of a paginated endpoint
#'
#' Iterates through all pages of a Cloudflare list endpoint and
#' concatenates the `result` arrays into a single list.
#'
#' @inheritParams cf_request
#' @param per_page Integer page size. Cloudflare caps most endpoints
#'   at 50; some allow up to 1000.
#' @param max_pages Optional integer. Stop after collecting this
#'   many pages. Useful for exploratory calls against large
#'   accounts. `Inf` (the default) collects everything.
#'
#' @return A list of records.
#' @export
#' @family requests
#' @examples
#' \dontrun{
#' cf_request_collect("zones", per_page = 50)
#' }
cf_request_collect <- function(
  endpoint,
  query = NULL,
  per_page = 50,
  max_pages = Inf,
  token = NULL,
  email = NULL,
  api_key = NULL,
  ...
) {
  query <- c(query, list(per_page = per_page))
  results <- list()
  page <- 1L
  repeat {
    query$page <- page
    resp <- cf_perform(
      endpoint,
      method = "GET",
      query = query,
      body = NULL,
      token = token,
      email = email,
      api_key = api_key,
      ...
    )
    env <- cf_resp_envelope(resp)
    results <- c(results, env$result)
    total_pages <- env$result_info$total_pages %||% 1L
    if (page >= total_pages || page >= max_pages) {
      break
    }
    page <- page + 1L
  }
  results
}

#' Build and perform a request, returning the raw response
#' @keywords internal
#' @noRd
cf_perform <- function(
  endpoint,
  method = "GET",
  query = NULL,
  body = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL,
  ...
) {
  req <- cf_req(token = token, email = email, api_key = api_key) |>
    cf_req_path(endpoint) |>
    httr2::req_method(method)

  query <- drop_nulls(query)
  if (length(query)) {
    req <- rlang::inject(httr2::req_url_query(req, !!!query))
  }
  if (!is.null(body)) {
    req <- httr2::req_body_json(req, body)
  }
  httr2::req_perform(req, ...)
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

#' Format the `errors` array from a Cloudflare envelope into
#' user-readable strings. Exposed as a helper for `cf_resp_envelope()`
#' and any caller that wants to inspect the raw error list.
#' @keywords internal
#' @noRd
cf_error_body <- function(resp) {
  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = FALSE),
    error = function(e) NULL
  )
  if (is.null(body) || !length(body$errors)) {
    return("Cloudflare returned an error with no parseable details.")
  }
  format_cf_errors(body$errors)
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
  parts <- strsplit(endpoint, "/", fixed = TRUE)[[1]]
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
