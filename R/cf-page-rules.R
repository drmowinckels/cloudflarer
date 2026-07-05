#' List Page Rules for a zone
#'
#' Returns the Page Rules configured for a zone (URL-pattern based
#' overrides for cache, SSL, security, redirects, etc.).
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param status Optional status filter (`"active"` or
#'   `"disabled"`).
#' @param order Optional ordering, see the Cloudflare API
#'   reference. For example `"priority"` or `"status"`.
#' @param direction Optional sort direction, `"asc"` or
#'   `"desc"`.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of page rules (or list when
#'   `as_df = FALSE`). Each rule's `targets` and `actions` are
#'   kept as list-columns because they are themselves arrays of
#'   nested objects.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_list_page_rules("abc123")
#' }
cf_list_page_rules <- function(
  zone_id,
  status = NULL,
  order = NULL,
  direction = NULL,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  records <- cf_request(
    c("zones", zone_id, "pagerules"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_url_query(
      status = status,
      order = order,
      direction = direction
    ) |>
    httr2::req_perform() |>
    cf_resp()
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Page Rule
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param rule_id Character. Page Rule identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the rule, including its
#'   `targets` and `actions`.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_get_page_rule("abc123", "rule-1")
#' }
cf_get_page_rule <- function(
  zone_id,
  rule_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(rule_id)
  cf_request(
    c("zones", zone_id, "pagerules", rule_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Create a Page Rule
#'
#' Each rule applies a list of `actions` whenever a request matches
#' one of `targets`. The most common pattern: a single URL-match
#' target plus one cache-related action (for example
#' `cache_level = "cache_everything"` to bump a static site's hit
#' ratio).
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param targets A list of target specifications. The simplest
#'   form is a single URL-match created by [cf_page_rule_target()];
#'   see the example below.
#' @param actions A list of action specifications. The simplest
#'   form is a list created by [cf_page_rule_action()].
#' @param priority Integer. Higher number = applied first.
#' @param status `"active"` or `"disabled"`.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created rule.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_create_page_rule(
#'   zone_id,
#'   targets = list(
#'     cf_page_rule_target("*example.com/blog/*")
#'   ),
#'   actions = list(
#'     cf_page_rule_action("cache_level", "cache_everything"),
#'     cf_page_rule_action("edge_cache_ttl", 7200)
#'   )
#' )
#' }
cf_create_page_rule <- function(
  zone_id,
  targets,
  actions,
  priority = 1L,
  status = c("active", "disabled"),
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  status <- match.arg(status)
  cf_request(
    c("zones", zone_id, "pagerules"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(
      targets = targets,
      actions = actions,
      priority = priority,
      status = status
    )) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Update a Page Rule
#'
#' Performs a `PATCH`. Only supply fields you want to change.
#' Targets and actions are full replacements when supplied.
#'
#' @inheritParams cf_create_page_rule
#' @param rule_id Character. Page Rule identifier.
#'
#' @return A named list describing the updated rule.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_update_page_rule(zone_id, "rule-1", status = "disabled")
#' }
cf_update_page_rule <- function(
  zone_id,
  rule_id,
  targets = NULL,
  actions = NULL,
  priority = NULL,
  status = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(rule_id)
  if (!is.null(status)) {
    status <- match.arg(status, c("active", "disabled"))
  }
  body <- drop_nulls(list(
    targets = targets,
    actions = actions,
    priority = priority,
    status = status
  ))
  cf_request(
    c("zones", zone_id, "pagerules", rule_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PATCH") |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete a Page Rule
#'
#' @inheritParams cf_update_page_rule
#'
#' @return A named list with the deleted rule's `id`.
#' @export
#' @family zones
#' @examples
#' \dontrun{
#' cf_delete_page_rule(zone_id, "rule-1")
#' }
cf_delete_page_rule <- function(
  zone_id,
  rule_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(rule_id)
  cf_request(
    c("zones", zone_id, "pagerules", rule_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
}

#' Build a Page Rule URL-match target
#'
#' Produces the nested list that the Cloudflare API expects for the
#' most common Page Rule target: a URL pattern with `matches`
#' semantics (asterisks act as wildcards). Use it inside a
#' `targets = list(...)` argument to [cf_create_page_rule()].
#'
#' @param url_pattern Character. The URL pattern, for example
#'   `"*example.com/blog/*"`.
#'
#' @return A named list ready to splice into `targets`.
#' @export
#' @family zones
#' @examples
#' cf_page_rule_target("*example.com/blog/*")
cf_page_rule_target <- function(url_pattern) {
  list(
    target = "url",
    constraint = list(
      operator = "matches",
      value = url_pattern
    )
  )
}

#' Build a Page Rule action
#'
#' Produces the nested list that the Cloudflare API expects for a
#' single Page Rule action. Use it inside an `actions = list(...)`
#' argument to [cf_create_page_rule()] or
#' [cf_update_page_rule()].
#'
#' Common `id` values: `"cache_level"`,
#' `"edge_cache_ttl"`, `"browser_cache_ttl"`,
#' `"always_use_https"`, `"security_level"`, `"ssl"`,
#' `"forwarding_url"`.
#'
#' @param id Character. The action name (Cloudflare's "setting"
#'   identifier).
#' @param value The value to set. For most actions this is a
#'   character or integer scalar; some (for example
#'   `"forwarding_url"`) expect a nested list.
#'
#' @return A named list ready to splice into `actions`.
#' @export
#' @family zones
#' @examples
#' cf_page_rule_action("cache_level", "cache_everything")
#' cf_page_rule_action("edge_cache_ttl", 7200)
#' cf_page_rule_action(
#'   "forwarding_url",
#'   list(url = "https://example.com/$1", status_code = 301)
#' )
cf_page_rule_action <- function(id, value) {
  list(id = id, value = value)
}
