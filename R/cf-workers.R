#' List Workers scripts in an account
#'
#' Returns the Workers scripts deployed in the supplied account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of Workers script records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family workers
#' @examples
#' \dontrun{
#' cf_list_workers_scripts("abc123")
#' }
cf_list_workers_scripts <- function(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  records <- cf_request(
    paste0("accounts/", account_id, "/workers/scripts"),
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get metadata for a single Workers script
#'
#' Returns the script's metadata (placement, bindings, etc.). To
#' fetch the actual source, use the API's
#' `/workers/scripts/{name}/content` endpoint via [cf_request()].
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param script_name Character. Worker script name.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with the script metadata.
#' @export
#' @family workers
#' @examples
#' \dontrun{
#' cf_get_workers_script("abc123", "my-worker")
#' }
cf_get_workers_script <- function(
  account_id,
  script_name,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(script_name)
  cf_request(
    paste0("accounts/", account_id, "/workers/scripts/", script_name),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Workers invocations over time
#'
#' Wraps the Cloudflare GraphQL `workersInvocationsAdaptive` node
#' to return a tidy data.frame with one row per time bin and one
#' row per Worker script.
#'
#' Requires an API token with `Account Analytics: Read` (or the
#' legacy Global API Key).
#'
#' @param account_id Character. Cloudflare account identifier
#'   (`accountTag` in GraphQL).
#' @param since,until Date or `POSIXct`. Half-open `[since, until)`.
#' @param script_name Optional Worker script name filter.
#' @param limit Maximum number of rows.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame with columns `date`, `script`, `requests`,
#'   `errors`, `subrequests`, `duration_ms`.
#' @export
#' @family analytics
#' @family workers
#' @examples
#' \dontrun{
#' cf_workers_invocations(
#'   account_id,
#'   since = Sys.Date() - 7,
#'   until = Sys.Date()
#' )
#' }
cf_workers_invocations <- function(
  account_id,
  since,
  until,
  script_name = NULL,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  filter_extra <- if (is.null(script_name)) "" else ", scriptName: $script"
  vars_extra <- if (is.null(script_name)) "" else ", $script: String!"
  query <- sprintf(
    "query Wrk($accountTag: String!, $since: Time!, $until: Time!,
              $limit: Int!%s) {
      viewer {
        accounts(filter: { accountTag: $accountTag }) {
          workersInvocationsAdaptive(
            limit: $limit,
            filter: { datetime_geq: $since, datetime_lt: $until%s },
            orderBy: [date_ASC]
          ) {
            dimensions { date scriptName }
            sum {
              requests
              errors
              subrequests
            }
            quantiles { cpuTimeP50 cpuTimeP99 }
          }
        }
      }
    }",
    vars_extra,
    filter_extra
  )
  args <- list(
    query,
    accountTag = account_id,
    since = format_iso8601(since),
    until = format_iso8601(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  if (!is.null(script_name)) {
    args$script <- script_name
  }
  res <- do.call(cf_graphql, args)
  groups <- res$data$viewer$accounts[[1]]$workersInvocationsAdaptive
  if (!length(groups)) {
    return(as_cf_tibble(data.frame(
      date = character(0),
      script = character(0),
      requests = integer(0),
      errors = integer(0),
      subrequests = integer(0),
      cpu_p50_us = numeric(0),
      cpu_p99_us = numeric(0),
      stringsAsFactors = FALSE
    )))
  }
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions$date, character(1)),
    script = vapply(groups, function(g) g$dimensions$scriptName, character(1)),
    requests = vapply(
      groups,
      function(g) as.integer(g$sum$requests),
      integer(1)
    ),
    errors = vapply(groups, function(g) as.integer(g$sum$errors), integer(1)),
    subrequests = vapply(
      groups,
      function(g) as.integer(g$sum$subrequests),
      integer(1)
    ),
    cpu_p50_us = vapply(
      groups,
      function(g) as.numeric(g$quantiles$cpuTimeP50 %||% NA_real_),
      numeric(1)
    ),
    cpu_p99_us = vapply(
      groups,
      function(g) as.numeric(g$quantiles$cpuTimeP99 %||% NA_real_),
      numeric(1)
    ),
    stringsAsFactors = FALSE
  ))
}
