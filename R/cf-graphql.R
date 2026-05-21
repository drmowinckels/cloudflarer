#' Run a Cloudflare GraphQL Analytics query
#'
#' Cloudflare's [Analytics GraphQL API](https://developers.cloudflare.com/analytics/graphql-api/)
#' exposes most current and historical analytics datasets (HTTP
#' requests, DNS, firewall, Workers, R2, etc.) behind a single
#' endpoint: `POST /graphql`. The response shape is the standard
#' GraphQL `{data, errors}` envelope, not Cloudflare's REST
#' envelope, so this function is a separate path from
#' [cf_request()].
#'
#' Variables are passed through `...` as named arguments, the same
#' pattern used by the meetupr package. All values must be named;
#' an unnamed value raises an error before the request is made.
#'
#' @param query Character. A GraphQL query string.
#' @param ... Named GraphQL variables. For example
#'   `cf_graphql(query, zoneTag = "abc", limit = 10)`.
#' @param .operation_name Optional operation name when the query
#'   contains multiple operations.
#' @param .token,.email,.api_key Optional per-call credentials.
#'   Dot-prefixed to avoid clashing with GraphQL variable names.
#'   See [cf_token()], [cf_email()], [cf_api_key()].
#' @param .envir Environment for error reporting. Defaults to the
#'   caller, so error messages point at the user's code.
#'
#' @return The parsed response body, including `data` and
#'   (when present) `extensions`. Any non-empty `errors` array
#'   raises a classed `cloudflarer_error`.
#'
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' res <- cf_graphql(
#'   "query Viewer($accountTag: String!) {
#'      viewer {
#'        accounts(filter: { accountTag: $accountTag }) {
#'          accountTag
#'        }
#'      }
#'    }",
#'   accountTag = "abc123"
#' )
#' res$data$viewer$accounts
#'
#' res <- cf_graphql(
#'   "
#'   query ZoneRequests($zoneTag: String!, $since: Date!, $until: Date!) {
#'     viewer {
#'       zones(filter: { zoneTag: $zoneTag }) {
#'         httpRequests1dGroups(
#'           limit: 100,
#'           filter: { date_geq: $since, date_lt: $until }
#'         ) {
#'           dimensions { date }
#'           sum { requests bytes pageViews }
#'           uniq { uniques }
#'         }
#'       }
#'     }
#'   }
#'   ",
#'   zoneTag = "abc123",
#'   since = "2026-05-01",
#'   until = "2026-05-08"
#' )
#' }
cf_graphql <- function(
  query,
  ...,
  .operation_name = NULL,
  .token = NULL,
  .email = NULL,
  .api_key = NULL,
  .envir = parent.frame()
) {
  variables <- rlang::list2(...)
  validate_graphql_variables(variables, .envir = .envir)

  resp <- build_graphql_request(
    query = query,
    variables = variables,
    operation_name = .operation_name,
    token = .token,
    email = .email,
    api_key = .api_key
  ) |>
    httr2::req_perform()

  cf_graphql_envelope(resp, .envir = .envir)
}

#' Build an httr2 request that targets the GraphQL endpoint
#' @keywords internal
#' @noRd
build_graphql_request <- function(
  query,
  variables = list(),
  operation_name = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  if (length(variables) == 0L || is.null(variables)) {
    variables <- structure(list(), names = character(0))
  }
  body <- list(query = query, variables = variables)
  if (!is.null(operation_name)) {
    body$operationName <- operation_name
  }
  cf_req(token = token, email = email, api_key = api_key) |>
    httr2::req_url_path_append("graphql") |>
    httr2::req_method("POST") |>
    httr2::req_body_json(body, auto_unbox = TRUE)
}

#' Parse the standard GraphQL `{data, errors}` envelope
#' @keywords internal
#' @noRd
cf_graphql_envelope <- function(resp, .envir = parent.frame()) {
  status <- httr2::resp_status(resp)
  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = FALSE),
    error = function(e) NULL
  )
  if (is.null(body)) {
    cli::cli_abort(
      c(
        "Cloudflare GraphQL returned a non-JSON response.",
        i = sprintf("HTTP status: %d", status)
      ),
      class = "cloudflarer_error",
      status_code = status,
      call = .envir
    )
  }
  if (length(body$errors)) {
    parts <- vapply(body$errors, format_graphql_error, character(1))
    cli::cli_abort(
      c("Cloudflare GraphQL request failed.", parts),
      class = "cloudflarer_error",
      status_code = status,
      errors = body$errors,
      call = .envir
    )
  }
  body
}

format_graphql_error <- function(e) {
  msg <- e$message %||% "Unknown error"
  msg <- gsub("\\{", "{{", gsub("\\}", "}}", msg))
  if (length(e$path)) {
    msg <- paste0(
      msg,
      " (path: ",
      paste(unlist(e$path), collapse = "."),
      ")"
    )
  }
  msg
}

validate_graphql_variables <- function(variables, .envir = parent.frame()) {
  if (length(variables) == 0L) {
    return(invisible(variables))
  }
  nms <- names(variables)
  if (is.null(nms) || any(!nzchar(nms))) {
    cli::cli_abort(
      c(
        "All GraphQL variables must be named.",
        i = "Pass them as named arguments, e.g. {.code cf_graphql(query, zoneTag = \"abc\")}."
      ),
      class = "cloudflarer_error",
      call = .envir
    )
  }
  invisible(variables)
}
