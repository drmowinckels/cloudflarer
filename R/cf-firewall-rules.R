#' List firewall rules for a zone
#'
#' Returns the firewall rules (expression-based custom rules)
#' configured for the zone. This is the classic firewall-rules
#' endpoint; for the newer Rulesets API use [cf_request()] against
#' `/zones/{id}/rulesets`.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of firewall rules (or list when
#'   `as_df = FALSE`). Each rule's `filter` nested object becomes
#'   a list-column.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_list_firewall_rules("abc123")
#' }
cf_list_firewall_rules <- function(
  zone_id,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  records <- cf_request_collect(
    paste0("zones/", zone_id, "/firewall/rules"),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}
