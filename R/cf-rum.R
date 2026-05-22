#' List Web Analytics (RUM) sites
#'
#' Lists sites configured with the Cloudflare Web Analytics beacon
#' in the supplied account. Web Analytics works on any site that
#' includes the beacon snippet, whether or not the site is proxied
#' through Cloudflare.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param order_by Optional column name to sort by, for example
#'   `"created"` or `"host"`.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` to get the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of site records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' cf_list_rum_sites("acc-1")
#' }
cf_list_rum_sites <- function(
  account_id,
  order_by = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  records <- cf_request_collect(
    paste0("accounts/", account_id, "/rum/site_info/list"),
    query = list(order_by = order_by),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Web Analytics (RUM) site
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param site_tag Character. RUM site tag (sometimes called
#'   "site identifier").
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the site.
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' cf_get_rum_site("acc-1", "abc-tag")
#' }
cf_get_rum_site <- function(
  account_id,
  site_tag,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(site_tag)
  cf_request(
    paste0("accounts/", account_id, "/rum/site_info/", site_tag),
    token = token,
    email = email,
    api_key = api_key
  )
}
