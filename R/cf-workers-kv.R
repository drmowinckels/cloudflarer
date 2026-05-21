#' List Workers KV namespaces
#'
#' Returns the KV namespaces in the supplied account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of KV namespace records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family workers
#' @examples
#' \dontrun{
#' cf_list_kv_namespaces("abc123")
#' }
cf_list_kv_namespaces <- function(
  account_id,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    paste0("accounts/", account_id, "/storage/kv/namespaces"),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Workers KV namespace
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param namespace_id Character. KV namespace identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the namespace.
#' @export
#' @family workers
#' @examples
#' \dontrun{
#' cf_get_kv_namespace("abc123", "ns-1")
#' }
cf_get_kv_namespace <- function(
  account_id,
  namespace_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("accounts/", account_id, "/storage/kv/namespaces/", namespace_id),
    token = token,
    email = email,
    api_key = api_key
  )
}
