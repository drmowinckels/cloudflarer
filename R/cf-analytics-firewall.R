#' Daily firewall event counts for a zone
#'
#' Wraps the Cloudflare GraphQL `firewallEventsAdaptiveGroups`
#' node, grouped by day. Returns a tidy data.frame with one row
#' per day.
#'
#' Requires:
#'
#' * A Cloudflare **Pro, Business, or Enterprise** plan -- the
#'   underlying GraphQL node is not available on the Free plan.
#' * An API token with `Account Analytics: Read` (or
#'   `Zone Analytics: Read`) permission, or the legacy Global API
#'   Key.
#'
#' Either condition unmet produces a `zone ... does not have access
#' to the path` error.
#'
#' @param zone_id Character. Cloudflare zone identifier
#'   (`zoneTag` in GraphQL).
#' @param since,until Date or `POSIXct`. Half-open `[since, until)`.
#' @param limit Maximum number of rows. Cloudflare caps the
#'   underlying query at 10000.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame with columns `date` (chr) and `events`
#'   (int).
#' @export
#' @family analytics
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_firewall_events_by_day",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_firewall_events_by_day(
#'   "abc123",
#'   since = Sys.Date() - 30,
#'   until = Sys.Date()
#' )
#' \dontshow{vcr::eject_cassette()}
cf_firewall_events_by_day <- function(
  zone_id,
  since,
  until,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  query <- "
  query FwDaily($zoneTag: String!, $since: Time!, $until: Time!,
                $limit: Int!) {
    viewer {
      zones(filter: { zoneTag: $zoneTag }) {
        firewallEventsAdaptiveGroups(
          limit: $limit,
          filter: { datetime_geq: $since, datetime_lt: $until },
          orderBy: [date_ASC]
        ) {
          count
          dimensions { date }
        }
      }
    }
  }
  "
  res <- cf_graphql(
    query,
    zoneTag = zone_id,
    since = format_iso8601(since),
    until = format_iso8601(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  groups <- res$data$viewer$zones[[1]]$firewallEventsAdaptiveGroups
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions$date, character(1)),
    events = vapply(groups, function(g) as.integer(g$count), integer(1)),
    stringsAsFactors = FALSE
  ))
}

#' Top firewall events for a zone by a chosen dimension
#'
#' Groups `firewallEventsAdaptiveGroups` by a single dimension
#' and returns the top entries by count.
#'
#' @inheritParams cf_firewall_events_by_day
#' @param dimension Character. Dimension name to group by. Common
#'   choices: `"action"` (block, challenge, ...), `"source"` (WAF,
#'   firewall rules, security level, ...), `"ruleId"`,
#'   `"clientCountryName"`, `"clientRequestPath"`,
#'   `"clientRequestHTTPHost"`, `"userAgent"`. Must be a single
#'   field name (letters, digits, underscores; not starting with a
#'   digit) and cannot be `"events"`, which names the metric
#'   column.
#' @param limit Number of rows to return.
#'
#' @return A data.frame with two columns: the requested
#'   `dimension` and `events` (the event count).
#' @export
#' @family analytics
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_firewall_events_top",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_firewall_events_top(
#'   "abc123",
#'   since = Sys.Date() - 7,
#'   until = Sys.Date(),
#'   dimension = "action",
#'   limit = 10
#' )
#' \dontshow{vcr::eject_cassette()}
cf_firewall_events_top <- function(
  zone_id,
  since,
  until,
  dimension = "action",
  limit = 25L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  metric_col <- "events"
  cf_check_id(zone_id)
  cf_check_dimension_name(dimension, metric_col)
  query <- sprintf(
    "query FwTop($zoneTag: String!, $since: Time!, $until: Time!,
                 $limit: Int!) {
      viewer {
        zones(filter: { zoneTag: $zoneTag }) {
          firewallEventsAdaptiveGroups(
            limit: $limit,
            filter: { datetime_geq: $since, datetime_lt: $until },
            orderBy: [count_DESC]
          ) {
            count
            dimensions { %s }
          }
        }
      }
    }",
    dimension
  )
  res <- cf_graphql(
    query,
    zoneTag = zone_id,
    since = format_iso8601(since),
    until = format_iso8601(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  groups <- res$data$viewer$zones[[1]]$firewallEventsAdaptiveGroups
  out <- data.frame(
    .x = vapply(
      groups,
      function(g) as.character(g$dimensions[[dimension]]),
      character(1)
    ),
    .y = vapply(groups, function(g) as.integer(g$count), integer(1)),
    stringsAsFactors = FALSE
  )
  names(out) <- c(dimension, metric_col)
  as_cf_tibble(out)
}
