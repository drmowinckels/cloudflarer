#' Daily cache hit ratio for a zone
#'
#' Wraps the same GraphQL `httpRequests1dGroups` node as
#' [cf_zone_requests()] but exposes the cache-specific fields:
#' total requests/bytes, cached requests/bytes, and the derived
#' cache hit ratios.
#'
#' @inheritParams cf_firewall_events_by_day
#'
#' @return A data.frame with columns `date` (chr), `requests`,
#'   `cached_requests`, `bytes`, `cached_bytes`,
#'   `request_hit_ratio`, `bandwidth_hit_ratio`.
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' cf_cache_ratio(
#'   "abc123",
#'   since = Sys.Date() - 7,
#'   until = Sys.Date()
#' )
#' }
cf_cache_ratio <- function(
  zone_id,
  since,
  until,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  query <- "
  query CacheDaily($zoneTag: String!, $since: Date!, $until: Date!,
                   $limit: Int!) {
    viewer {
      zones(filter: { zoneTag: $zoneTag }) {
        httpRequests1dGroups(
          limit: $limit,
          filter: { date_geq: $since, date_lt: $until },
          orderBy: [date_ASC]
        ) {
          dimensions { date }
          sum {
            requests
            cachedRequests
            bytes
            cachedBytes
          }
        }
      }
    }
  }
  "
  res <- cf_graphql(
    query,
    zoneTag = zone_id,
    since = format_gql_date(since),
    until = format_gql_date(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  groups <- res$data$viewer$zones[[1]]$httpRequests1dGroups
  if (!length(groups)) {
    return(empty_cache_ratio_df())
  }
  requests <- vapply(
    groups,
    function(g) as.integer(g$sum$requests),
    integer(1)
  )
  cached_requests <- vapply(
    groups,
    function(g) as.integer(g$sum$cachedRequests),
    integer(1)
  )
  bytes <- vapply(groups, function(g) as.numeric(g$sum$bytes), numeric(1))
  cached_bytes <- vapply(
    groups,
    function(g) as.numeric(g$sum$cachedBytes),
    numeric(1)
  )
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions$date, character(1)),
    requests = requests,
    cached_requests = cached_requests,
    bytes = bytes,
    cached_bytes = cached_bytes,
    request_hit_ratio = ifelse(
      requests == 0L,
      NA_real_,
      cached_requests / requests
    ),
    bandwidth_hit_ratio = ifelse(bytes == 0, NA_real_, cached_bytes / bytes),
    stringsAsFactors = FALSE
  ))
}

empty_cache_ratio_df <- function() {
  as_cf_tibble(data.frame(
    date = character(0),
    requests = integer(0),
    cached_requests = integer(0),
    bytes = numeric(0),
    cached_bytes = numeric(0),
    request_hit_ratio = numeric(0),
    bandwidth_hit_ratio = numeric(0),
    stringsAsFactors = FALSE
  ))
}
