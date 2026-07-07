#' List SSL certificate packs in a zone
#'
#' Returns the SSL certificate packs (universal, advanced, custom)
#' issued for the zone.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param status Optional status filter, for example `"active"` or
#'   `"pending_validation"`.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of certificate pack records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_list_certificate_packs("zone-1")
#' cf_list_certificate_packs("zone-1", status = "active")
#' }
cf_list_certificate_packs <- function(
  zone_id,
  status = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    paste0("zones/", zone_id, "/ssl/certificate_packs"),
    query = list(status = status),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single SSL certificate pack
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param pack_id Character. Certificate pack identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the certificate pack.
#' @export
#' @family ssl
#' @examples
#' \dontrun{
#' cf_get_certificate_pack("zone-1", "pack-1")
#' }
cf_get_certificate_pack <- function(
  zone_id,
  pack_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("zones/", zone_id, "/ssl/certificate_packs/", pack_id),
    token = token,
    email = email,
    api_key = api_key
  )
}
