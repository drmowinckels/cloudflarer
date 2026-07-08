#' List standalone healthchecks in a zone
#'
#' Returns the standalone Healthchecks configured in the zone.
#' These are separate from load-balancer pool monitors.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of healthcheck records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family healthchecks
#' @examples
#' \dontrun{
#' cf_list_healthchecks("zone-1")
#' }
cf_list_healthchecks <- function(
  zone_id,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  records <- cf_request(
    c("zones", zone_id, "healthchecks"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single healthcheck
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param healthcheck_id Character. Healthcheck identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the healthcheck.
#' @export
#' @family healthchecks
#' @examples
#' \dontrun{
#' cf_get_healthcheck("zone-1", "hc-1")
#' }
cf_get_healthcheck <- function(
  zone_id,
  healthcheck_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(healthcheck_id)
  cf_request(
    c("zones", zone_id, "healthchecks", healthcheck_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Create a healthcheck
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param name Display name for the healthcheck.
#' @param address Hostname or IPv4/IPv6 address to monitor.
#' @param type One of `"HTTPS"`, `"HTTP"`, or `"TCP"`.
#' @param check_regions Optional character vector of Cloudflare region
#'   codes (`"WEU"`, `"ENAM"`, etc.). When `NULL`, the API runs the
#'   check from all available regions.
#' @param http_config Optional named list with HTTP/HTTPS-specific
#'   fields (`path`, `port`, `method`, `expected_codes`,
#'   `expected_body`, `follow_redirects`, `allow_insecure`, `header`).
#' @param tcp_config Optional named list with TCP-specific fields
#'   (`port`, `method`).
#' @param interval Polling interval in seconds.
#' @param retries Number of retries before marking unhealthy.
#' @param timeout Timeout per check, in seconds.
#' @param description Optional human-readable description.
#' @param suspended Logical. When `TRUE`, the check is paused.
#' @param ... Additional fields forwarded to the API.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created healthcheck.
#' @export
#' @family healthchecks
#' @examples
#' \dontrun{
#' cf_create_healthcheck(
#'   "zone-1",
#'   name    = "api-prod",
#'   address = "api.example.com",
#'   type    = "HTTPS",
#'   http_config = list(path = "/health", expected_codes = "200")
#' )
#' }
cf_create_healthcheck <- function(
  zone_id,
  name,
  address,
  type = "HTTPS",
  check_regions = NULL,
  http_config = NULL,
  tcp_config = NULL,
  interval = 60,
  retries = 2,
  timeout = 5,
  description = NULL,
  suspended = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  body <- drop_nulls(list(
    name = name,
    address = address,
    type = type,
    check_regions = check_regions,
    http_config = http_config,
    tcp_config = tcp_config,
    interval = interval,
    retries = retries,
    timeout = timeout,
    description = description,
    suspended = suspended,
    ...
  ))
  cf_check_id(zone_id)
  cf_request(
    c("zones", zone_id, "healthchecks"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Update a healthcheck
#'
#' Performs a `PATCH`, sending only fields supplied as non-`NULL`.
#'
#' @inheritParams cf_get_healthcheck
#' @inheritParams cf_create_healthcheck
#'
#' @return A named list describing the updated healthcheck.
#' @export
#' @family healthchecks
#' @examples
#' \dontrun{
#' cf_update_healthcheck("zone-1", "hc-1", suspended = TRUE)
#' }
cf_update_healthcheck <- function(
  zone_id,
  healthcheck_id,
  name = NULL,
  address = NULL,
  type = NULL,
  check_regions = NULL,
  http_config = NULL,
  tcp_config = NULL,
  interval = NULL,
  retries = NULL,
  timeout = NULL,
  description = NULL,
  suspended = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  body <- drop_nulls(list(
    name = name,
    address = address,
    type = type,
    check_regions = check_regions,
    http_config = http_config,
    tcp_config = tcp_config,
    interval = interval,
    retries = retries,
    timeout = timeout,
    description = description,
    suspended = suspended,
    ...
  ))
  cf_check_id(zone_id)
  cf_check_id(healthcheck_id)
  cf_request(
    c("zones", zone_id, "healthchecks", healthcheck_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PATCH") |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete a healthcheck
#'
#' @inheritParams cf_get_healthcheck
#'
#' @return A named list with the deleted healthcheck's `id`.
#' @export
#' @family healthchecks
#' @examples
#' \dontrun{
#' cf_delete_healthcheck("zone-1", "hc-1")
#' }
cf_delete_healthcheck <- function(
  zone_id,
  healthcheck_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(healthcheck_id)
  cf_request(
    c("zones", zone_id, "healthchecks", healthcheck_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
}
