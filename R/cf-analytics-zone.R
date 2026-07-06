#' Daily or hourly HTTP request totals for a zone
#'
#' Convenience wrapper around the Cloudflare GraphQL Analytics
#' `httpRequests1dGroups` (daily) or `httpRequests1hGroups`
#' (hourly) nodes. Returns a tidy data.frame with one row per time
#' bin and columns for requests, bytes, page views, threats, and
#' unique visitors.
#'
#' @param zone_id Character. Cloudflare zone identifier
#'   (`zoneTag` in GraphQL).
#' @param since,until Date or `POSIXct` (or pre-formatted character
#'   `"YYYY-MM-DD"` for `by = "day"` and `"YYYY-MM-DDTHH:MM:SSZ"`
#'   for `by = "hour"`). The interval is half-open `[since, until)`.
#' @param by Bin width: `"day"` or `"hour"`.
#' @param limit Maximum number of bins to return. Cloudflare caps
#'   the GraphQL query at 10000.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame with columns:
#'   `date` (chr; `"YYYY-MM-DD"` for daily, `"YYYY-MM-DDTHH:00:00Z"`
#'   for hourly), `requests`, `bytes`, `pageviews`, `threats`,
#'   `uniques`.
#'
#' @export
#' @family analytics
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' vcr::insert_example_cassette(
#'   "cf_zone_requests",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_zone_requests(
#'   "abc123",
#'   since = Sys.Date() - 7,
#'   until = Sys.Date(),
#'   by    = "day"
#' )
#'
#' cf_zone_requests(
#'   "abc123",
#'   since = Sys.time() - 24 * 3600,
#'   until = Sys.time(),
#'   by    = "hour"
#' )
#' \dontshow{vcr::eject_cassette()}
cf_zone_requests <- function(
  zone_id,
  since,
  until,
  by = c("day", "hour"),
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  by <- match.arg(by)
  node <- switch(
    by,
    day = "httpRequests1dGroups",
    hour = "httpRequests1hGroups"
  )
  dim_field <- switch(by, day = "date", hour = "datetime")
  order_by <- switch(by, day = "date_ASC", hour = "datetime_ASC")
  filter_keys <- switch(
    by,
    day = c("date_geq", "date_lt"),
    hour = c("datetime_geq", "datetime_lt")
  )

  since_val <- switch(
    by,
    day = format_gql_date(since),
    hour = format_iso8601(since)
  )
  until_val <- switch(
    by,
    day = format_gql_date(until),
    hour = format_iso8601(until)
  )

  query <- sprintf(
    "query ZoneReq($zoneTag: String!, $since: %s!, $until: %s!, $limit: Int!) {
       viewer {
         zones(filter: { zoneTag: $zoneTag }) {
           %s(
             limit: $limit,
             filter: { %s: $since, %s: $until },
             orderBy: [%s]
           ) {
             dimensions { %s }
             sum { requests bytes pageViews threats }
             uniq { uniques }
           }
         }
       }
     }",
    switch(by, day = "Date", hour = "Time"),
    switch(by, day = "Date", hour = "Time"),
    node,
    filter_keys[1],
    filter_keys[2],
    order_by,
    dim_field
  )

  res <- cf_graphql(
    query,
    zoneTag = zone_id,
    since = since_val,
    until = until_val,
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )

  groups <- res$data$viewer$zones[[1]][[node]]
  if (!length(groups)) {
    return(empty_zone_requests_df())
  }
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions[[dim_field]], character(1)),
    requests = vapply(groups, function(g) g$sum$requests, integer(1)),
    bytes = vapply(groups, function(g) as.numeric(g$sum$bytes), numeric(1)),
    pageviews = vapply(groups, function(g) g$sum$pageViews, integer(1)),
    threats = vapply(groups, function(g) g$sum$threats, integer(1)),
    uniques = vapply(groups, function(g) g$uniq$uniques, integer(1)),
    stringsAsFactors = FALSE
  ))
}

empty_zone_requests_df <- function() {
  as_cf_tibble(data.frame(
    date = character(0),
    requests = integer(0),
    bytes = numeric(0),
    pageviews = integer(0),
    threats = integer(0),
    uniques = integer(0),
    stringsAsFactors = FALSE
  ))
}
