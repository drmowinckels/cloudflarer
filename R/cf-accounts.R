#' List accounts
#'
#' Lists all accounts the authenticated user has access to.
#'
#' @param name Optional name filter passed to the API.
#' @param per_page Page size, see [cf_collect()].
#' @param max_pages Maximum number of pages to retrieve, see
#'   [cf_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` to get the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of account records (or a list when
#'   `as_df = FALSE`).
#' @export
#' @family accounts
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_accounts", package = "cloudflarer")
#' }
#' cf_list_accounts()
#' \dontshow{vcr::eject_cassette()}
cf_list_accounts <- function(
  name = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request(
    "accounts",
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_url_query(name = name) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single account
#'
#' @param account_id Character. Cloudflare account identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the account.
#' @export
#' @family accounts
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_account", package = "cloudflarer")
#' }
#' cf_get_account("abc123")
#' \dontshow{vcr::eject_cassette()}
cf_get_account <- function(
  account_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_request(
    c("accounts", account_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}
