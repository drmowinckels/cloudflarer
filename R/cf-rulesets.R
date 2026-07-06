#' List Rulesets for a zone
#'
#' Returns the rulesets configured at the zone level. The
#' Rulesets API is Cloudflare's modern, unified surface for
#' firewall rules, request transforms, cache rules, rate limits,
#' redirects, and more.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of rulesets (or list when
#'   `as_df = FALSE`).
#' @export
#' @family rulesets
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette("cf_list_rulesets", package = "cloudflarer")
#' }
#' cf_list_rulesets("abc123")
#' \dontshow{vcr::eject_cassette()}
cf_list_rulesets <- function(
  zone_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  records <- cf_request(
    c("zones", zone_id, "rulesets"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single zone Ruleset (with its rules)
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param ruleset_id Character. Ruleset identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the ruleset; its `rules` element
#'   is itself a list of rule objects.
#' @export
#' @family rulesets
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette("cf_get_ruleset", package = "cloudflarer")
#' }
#' cf_get_ruleset("abc123", "rs-1")
#' \dontshow{vcr::eject_cassette()}
cf_get_ruleset <- function(
  zone_id,
  ruleset_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(ruleset_id)
  cf_request(
    c("zones", zone_id, "rulesets", ruleset_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' List Rulesets for an account
#'
#' Returns the rulesets configured at the account level (typically
#' the curated managed rulesets you can deploy with overrides).
#'
#' @param account_id Character. Cloudflare account identifier.
#' @inheritParams cf_list_rulesets
#'
#' @return A data.frame of rulesets (or list when
#'   `as_df = FALSE`).
#' @export
#' @family rulesets
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette("cf_list_account_rulesets", package = "cloudflarer")
#' }
#' cf_list_account_rulesets("acc-1")
#' \dontshow{vcr::eject_cassette()}
cf_list_account_rulesets <- function(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  records <- cf_request(
    c("accounts", account_id, "rulesets"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single account Ruleset (with its rules)
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param ruleset_id Character. Ruleset identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the ruleset; its `rules` element
#'   is itself a list of rule objects.
#' @export
#' @family rulesets
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette("cf_get_account_ruleset", package = "cloudflarer")
#' }
#' cf_get_account_ruleset("acc-1", "rs-1")
#' \dontshow{vcr::eject_cassette()}
cf_get_account_ruleset <- function(
  account_id,
  ruleset_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(ruleset_id)
  cf_request(
    c("accounts", account_id, "rulesets", ruleset_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}
