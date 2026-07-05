#' Get the authenticated user
#'
#' Returns information about the user that owns the API token.
#'
#' @inheritParams cf_token
#'
#' @return A named list of user fields, including `id`, `email`,
#'   `first_name`, `last_name`, and `organizations`.
#' @export
#' @family user
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette("cf_user", package = "cloudflarer")
#' }
#' cf_user()
#' \dontshow{vcr::eject_cassette()}
cf_user <- function(token = NULL) {
  cf_request("user", token = token) |>
    httr2::req_perform() |>
    cf_resp()
}
