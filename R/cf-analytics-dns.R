#' Daily DNS query counts for a zone
#'
#' Wraps the Cloudflare GraphQL `dnsAnalyticsAdaptiveGroups` node,
#' grouped by day. Returns a tidy data.frame.
#'
#' Requires an API token with the `Account Analytics: Read` (or
#' `Zone Analytics: Read`) permission. The legacy Global API Key
#' has full access.
#'
#' @inheritParams cf_firewall_events_by_day
#'
#' @return A data.frame with columns `date` (chr) and `queries`
#'   (int).
#' @export
#' @family analytics
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_dns_queries",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_dns_queries(
#'   "abc123",
#'   since = Sys.Date() - 7,
#'   until = Sys.Date()
#' )
#' \dontshow{vcr::eject_cassette()}
cf_dns_queries <- function(
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
  query DnsDaily($zoneTag: String!, $since: Time!, $until: Time!,
                 $limit: Int!) {
    viewer {
      zones(filter: { zoneTag: $zoneTag }) {
        dnsAnalyticsAdaptiveGroups(
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
  groups <- res$data$viewer$zones[[1]]$dnsAnalyticsAdaptiveGroups
  if (!length(groups)) {
    return(as_cf_tibble(data.frame(
      date = character(0),
      queries = integer(0),
      stringsAsFactors = FALSE
    )))
  }
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions$date, character(1)),
    queries = vapply(groups, function(g) as.integer(g$count), integer(1)),
    stringsAsFactors = FALSE
  ))
}
