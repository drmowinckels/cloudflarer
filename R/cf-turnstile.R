#' List Turnstile widgets
#'
#' Lists the Turnstile (Cloudflare's CAPTCHA replacement) widgets
#' configured in an account.
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
#' @return A data.frame of widget records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family turnstile
#' @examples
#' \dontrun{
#' cf_list_turnstile_widgets("abc123")
#' }
cf_list_turnstile_widgets <- function(
  account_id,
  per_page = 25,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  records <- cf_request_collect(
    paste0("accounts/", account_id, "/challenges/widgets"),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Turnstile widget
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param sitekey Character. Widget sitekey.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the widget.
#' @export
#' @family turnstile
#' @examples
#' \dontrun{
#' cf_get_turnstile_widget("abc123", "0x4AAA...")
#' }
cf_get_turnstile_widget <- function(
  account_id,
  sitekey,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(sitekey)
  cf_request(
    paste0("accounts/", account_id, "/challenges/widgets/", sitekey),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Create a Turnstile widget
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param name Character. Human-readable widget name.
#' @param domains Character vector of domains where the widget
#'   will be embedded.
#' @param mode Character. Visibility mode: `"managed"` (Cloudflare
#'   decides), `"non-interactive"` (no user interaction), or
#'   `"invisible"`.
#' @param bot_fight_mode Logical. Enable Bot Fight Mode integration.
#' @param region Character. Where Turnstile runs from. `"world"`
#'   (default) or `"china"`.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with the created widget, including its
#'   `sitekey` and `secret` (only shown once).
#' @export
#' @family turnstile
#' @examples
#' \dontrun{
#' cf_create_turnstile_widget(
#'   "abc123",
#'   name = "comment-form",
#'   domains = c("example.com", "www.example.com"),
#'   mode = "managed"
#' )
#' }
cf_create_turnstile_widget <- function(
  account_id,
  name,
  domains,
  mode = c(
    "managed",
    "non-interactive",
    "invisible"
  ),
  bot_fight_mode = FALSE,
  region = "world",
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  mode <- match.arg(mode)
  cf_request(
    paste0("accounts/", account_id, "/challenges/widgets"),
    method = "POST",
    body = list(
      name = name,
      domains = as.list(domains),
      mode = mode,
      bot_fight_mode = bot_fight_mode,
      region = region
    ),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Delete a Turnstile widget
#'
#' @inheritParams cf_get_turnstile_widget
#'
#' @return A named list with the deleted widget's `sitekey`.
#' @export
#' @family turnstile
#' @examples
#' \dontrun{
#' cf_delete_turnstile_widget("abc123", "0x4AAA...")
#' }
cf_delete_turnstile_widget <- function(
  account_id,
  sitekey,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(sitekey)
  cf_request(
    paste0("accounts/", account_id, "/challenges/widgets/", sitekey),
    method = "DELETE",
    token = token,
    email = email,
    api_key = api_key
  )
}
