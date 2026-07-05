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
#' @examples
#' \dontrun{
#' cf_user()
#' }
cf_user <- function(token = NULL) {
  cf_request("user", token = token) |>
    httr2::req_perform() |>
    cf_resp()
}
