#' List Cloudflare Tunnels
#'
#' Returns the cloudflared tunnels (Zero Trust) configured in the
#' supplied account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param is_deleted Logical. When `TRUE`, include deleted
#'   tunnels.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of tunnel records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family tunnels
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_tunnels", package = "cloudflarer")
#' }
#' cf_list_tunnels("abc123")
#' \dontshow{vcr::eject_cassette()}
cf_list_tunnels <- function(
  account_id,
  is_deleted = FALSE,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  records <- cf_request(
    c("accounts", account_id, "cfd_tunnel"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_url_query(is_deleted = cf_query_bool(is_deleted)) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Cloudflare Tunnel
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param tunnel_id Character. Tunnel identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the tunnel.
#' @export
#' @family tunnels
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_tunnel", package = "cloudflarer")
#' }
#' cf_get_tunnel("abc123", "tunnel-1")
#' \dontshow{vcr::eject_cassette()}
cf_get_tunnel <- function(
  account_id,
  tunnel_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(tunnel_id)
  cf_request(
    c("accounts", account_id, "cfd_tunnel", tunnel_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' List active connections for a Cloudflare Tunnel
#'
#' Returns the currently-connected `cloudflared` instances for the
#' tunnel.
#'
#' @inheritParams cf_get_tunnel
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of connection records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family tunnels
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_tunnel_connections", package = "cloudflarer")
#' }
#' cf_list_tunnel_connections("abc123", "tunnel-1")
#' \dontshow{vcr::eject_cassette()}
cf_list_tunnel_connections <- function(
  account_id,
  tunnel_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(tunnel_id)
  records <- cf_request(
    c("accounts", account_id, "cfd_tunnel", tunnel_id, "connections"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
  if (as_df) cf_records_to_df(records) else records
}
