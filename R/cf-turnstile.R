#' List Turnstile widgets
#'
#' Lists the Turnstile (Cloudflare's CAPTCHA replacement) widgets
#' configured in an account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_collect()].
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
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_turnstile_widgets", package = "cloudflarer")
#' }
#' cf_list_turnstile_widgets("abc123")
#' \dontshow{vcr::eject_cassette()}
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
  records <- cf_request(
    c("accounts", account_id, "challenges", "widgets"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
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
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_turnstile_widget", package = "cloudflarer")
#' }
#' cf_get_turnstile_widget("abc123", "0x4AAA...")
#' \dontshow{vcr::eject_cassette()}
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
    c("accounts", account_id, "challenges", "widgets", sitekey),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
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
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_create_turnstile_widget",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_create_turnstile_widget(
#'   "abc123",
#'   name = "comment-form",
#'   domains = c("example.com", "www.example.com"),
#'   mode = "managed"
#' )
#' \dontshow{vcr::eject_cassette()}
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
    c("accounts", account_id, "challenges", "widgets"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(
      name = name,
      domains = as.list(domains),
      mode = mode,
      bot_fight_mode = bot_fight_mode,
      region = region
    )) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete a Turnstile widget
#'
#' @inheritParams cf_get_turnstile_widget
#'
#' @return A named list with the deleted widget's `sitekey`.
#' @export
#' @family turnstile
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_delete_turnstile_widget", package = "cloudflarer")
#' }
#' cf_delete_turnstile_widget("abc123", "0x4AAA...")
#' \dontshow{vcr::eject_cassette()}
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
    c("accounts", account_id, "challenges", "widgets", sitekey),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
}
