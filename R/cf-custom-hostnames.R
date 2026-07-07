#' List custom hostnames in a zone
#'
#' Returns the SSL-for-SaaS custom hostnames attached to the zone.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param hostname Optional hostname filter (substring match).
#' @param ssl Optional SSL status filter (e.g. `"active"`,
#'   `"pending_validation"`).
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of custom hostname records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_list_custom_hostnames("zone-1")
#' }
cf_list_custom_hostnames <- function(
  zone_id,
  hostname = NULL,
  ssl = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    paste0("zones/", zone_id, "/custom_hostnames"),
    query = list(hostname = hostname, ssl = ssl),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single custom hostname
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param custom_hostname_id Character. Custom hostname identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the custom hostname.
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_get_custom_hostname("zone-1", "ch-1")
#' }
cf_get_custom_hostname <- function(
  zone_id,
  custom_hostname_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("zones/", zone_id, "/custom_hostnames/", custom_hostname_id),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Create a custom hostname
#'
#' Registers a customer hostname with SSL-for-SaaS.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param hostname Customer-facing hostname (e.g.
#'   `"shop.customer.com"`).
#' @param ssl_method Domain Control Validation method: `"http"`,
#'   `"txt"`, or `"email"`.
#' @param ssl_type Certificate type, typically `"dv"`.
#' @param ssl Optional named list overriding the default SSL config.
#'   When supplied, takes precedence over `ssl_method` / `ssl_type`.
#' @param custom_metadata Optional named list of metadata stored with
#'   the hostname.
#' @param custom_origin_server Optional custom origin server
#'   (overrides zone fallback).
#' @param ... Additional fields forwarded to the API.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created custom hostname.
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_create_custom_hostname(
#'   "zone-1",
#'   hostname   = "shop.customer.com",
#'   ssl_method = "txt"
#' )
#' }
cf_create_custom_hostname <- function(
  zone_id,
  hostname,
  ssl_method = "txt",
  ssl_type = "dv",
  ssl = NULL,
  custom_metadata = NULL,
  custom_origin_server = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  ssl_body <- ssl %||% list(method = ssl_method, type = ssl_type)
  body <- drop_nulls(list(
    hostname = hostname,
    ssl = ssl_body,
    custom_metadata = custom_metadata,
    custom_origin_server = custom_origin_server,
    ...
  ))
  cf_request(
    paste0("zones/", zone_id, "/custom_hostnames"),
    method = "POST",
    body = body,
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Delete a custom hostname
#'
#' @inheritParams cf_get_custom_hostname
#'
#' @return A named list with the deleted hostname's `id`.
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_delete_custom_hostname("zone-1", "ch-1")
#' }
cf_delete_custom_hostname <- function(
  zone_id,
  custom_hostname_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("zones/", zone_id, "/custom_hostnames/", custom_hostname_id),
    method = "DELETE",
    token = token,
    email = email,
    api_key = api_key
  )
}
