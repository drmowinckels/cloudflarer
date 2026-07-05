#' Email Routing settings for a zone
#'
#' Returns the current Email Routing configuration for the zone:
#' enabled/disabled, SPF/MX status, last-modified timestamps.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with the routing settings.
#' @export
#' @family email
#' @examples
#' \dontrun{
#' cf_get_email_routing_settings("abc123")
#' }
cf_get_email_routing_settings <- function(
  zone_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_request(
    c("zones", zone_id, "email", "routing"),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' List Email Routing rules for a zone
#'
#' Returns the address-matching rules that decide how incoming
#' emails are forwarded.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param enabled_only Logical. When `TRUE`, asks the API to
#'   return only enabled rules.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of routing rules (or list when
#'   `as_df = FALSE`).
#' @export
#' @family email
#' @examples
#' \dontrun{
#' cf_list_email_routing_rules("abc123")
#' }
cf_list_email_routing_rules <- function(
  zone_id,
  enabled_only = FALSE,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_flag(enabled_only)
  query <- if (enabled_only) list(enabled = "true") else NULL
  records <- cf_request_collect(
    c("zones", zone_id, "email", "routing", "rules"),
    query = query,
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' List Email Routing destination addresses
#'
#' Returns the verified destination addresses available for
#' routing in the account. Destinations are account-scoped, not
#' zone-scoped, because the same destination can be used across
#' multiple routed zones.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param verified_only Logical. When `TRUE`, asks the API to
#'   return only verified addresses.
#' @param per_page,max_pages Pagination controls.
#' @param as_df Logical. See [cf_list_email_routing_rules()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of destination addresses (or list when
#'   `as_df = FALSE`).
#' @export
#' @family email
#' @examples
#' \dontrun{
#' cf_list_email_routing_addresses("abc123")
#' }
cf_list_email_routing_addresses <- function(
  account_id,
  verified_only = FALSE,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_flag(verified_only)
  query <- if (verified_only) list(verified = "true") else NULL
  records <- cf_request_collect(
    c("accounts", account_id, "email", "routing", "addresses"),
    query = query,
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}
