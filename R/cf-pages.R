#' List Cloudflare Pages projects
#'
#' Returns the Pages projects in the supplied account. The Pages
#' projects endpoint does not accept pagination parameters
#' (unlike most other Cloudflare list endpoints) and returns
#' every project in a single call.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of Pages projects (or list when
#'   `as_df = FALSE`).
#' @export
#' @family pages
#' @examples
#' \dontrun{
#' cf_list_pages_projects("abc123")
#' }
cf_list_pages_projects <- function(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request(
    paste0("accounts/", account_id, "/pages/projects"),
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Cloudflare Pages project
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param project_name Character. Pages project name.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the project, including build
#'   config, domains, and the latest deployment.
#' @export
#' @family pages
#' @examples
#' \dontrun{
#' cf_get_pages_project("abc123", "my-site")
#' }
cf_get_pages_project <- function(
  account_id,
  project_name,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0(
      "accounts/",
      account_id,
      "/pages/projects/",
      project_name
    ),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' List deployments for a Pages project
#'
#' Returns the recent deployments (build history) for a Pages
#' project, ordered by date descending.
#'
#' @inheritParams cf_get_pages_project
#' @param per_page,max_pages Pagination controls.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of deployment records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family pages
#' @examples
#' \dontrun{
#' cf_list_pages_deployments("abc123", "my-site")
#' }
cf_list_pages_deployments <- function(
  account_id,
  project_name,
  per_page = 25,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    paste0(
      "accounts/",
      account_id,
      "/pages/projects/",
      project_name,
      "/deployments"
    ),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}
