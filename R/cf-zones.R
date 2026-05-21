#' List zones
#'
#' Lists the zones (domains) accessible to the authenticated
#' credential.
#'
#' @param name Optional zone name to filter by.
#' @param status Optional status filter (for example `"active"`).
#' @param account_id Optional account identifier to scope the
#'   listing.
#' @param per_page Page size, see [cf_request_collect()].
#' @param max_pages Maximum pages to retrieve, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of zone records (or a list when
#'   `as_df = FALSE`).
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_list_zones()
#' cf_list_zones(name = "example.com")
#' }
cf_list_zones <- function(
  name = NULL,
  status = NULL,
  account_id = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    "zones",
    query = list(
      name = name,
      status = status,
      "account.id" = account_id
    ),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single zone
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the zone.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_get_zone("abc123")
#' }
cf_get_zone <- function(zone_id, token = NULL, email = NULL, api_key = NULL) {
  cf_request(
    paste0("zones/", zone_id),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Get zone settings
#'
#' Returns the full settings catalogue for a zone (cache level,
#' SSL mode, minify, security level, ...). One row per setting.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of settings (or list when `as_df = FALSE`).
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_get_zone_settings("abc123")
#' }
cf_get_zone_settings <- function(
  zone_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request(
    paste0("zones/", zone_id, "/settings"),
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single zone setting
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param setting Character. Setting name (for example
#'   `"ssl"`, `"cache_level"`, `"security_level"`).
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with the setting's `id`, `value`,
#'   `modified_on`, and editability flags.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_get_zone_setting("abc123", "ssl")
#' }
cf_get_zone_setting <- function(
  zone_id,
  setting,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("zones/", zone_id, "/settings/", setting),
    token = token,
    email = email,
    api_key = api_key
  )
}
