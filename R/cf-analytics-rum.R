#' Daily page views for a Web Analytics (RUM) site
#'
#' Convenience wrapper around the GraphQL
#' `rumPageloadEventsAdaptiveGroups` node with a daily
#' (`date_DAY`) dimension. Returns a tidy data.frame.
#'
#' @param account_id Character. Cloudflare account identifier
#'   (`accountTag` in GraphQL).
#' @param site_tag Character. RUM site tag, as returned by
#'   [cf_list_rum_sites()].
#' @param since,until Date or `POSIXct` (or pre-formatted ISO-8601
#'   character strings). Half-open `[since, until)` interval.
#' @param limit Maximum number of days to return. Cloudflare caps
#'   the underlying query at 10000.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame with one row per day and columns
#'   `date` (chr) and `pageviews` (int).
#'
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' cf_rum_page_views(
#'   "acc-1",
#'   site_tag = "abc",
#'   since = Sys.Date() - 30,
#'   until = Sys.Date()
#' )
#' }
cf_rum_page_views <- function(
  account_id,
  site_tag,
  since,
  until,
  limit = 100L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  query <- "
  query Pv($accountTag: String!, $siteTag: String!,
           $since: Time!, $until: Time!, $limit: Int!) {
    viewer {
      accounts(filter: { accountTag: $accountTag }) {
        rumPageloadEventsAdaptiveGroups(
          limit: $limit,
          filter: {
            siteTag: $siteTag,
            datetime_geq: $since,
            datetime_lt: $until
          },
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
    accountTag = account_id,
    siteTag = site_tag,
    since = format_iso8601(since),
    until = format_iso8601(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  groups <- res$data$viewer$accounts[[1]]$rumPageloadEventsAdaptiveGroups
  if (!length(groups)) {
    return(as_cf_tibble(data.frame(
      date = character(0),
      pageviews = integer(0),
      stringsAsFactors = FALSE
    )))
  }
  as_cf_tibble(data.frame(
    date = vapply(groups, function(g) g$dimensions$date, character(1)),
    pageviews = vapply(groups, function(g) as.integer(g$count), integer(1)),
    stringsAsFactors = FALSE
  ))
}

#' Top dimensions for a Web Analytics (RUM) site
#'
#' Generic wrapper that groups RUM page-load events by a single
#' dimension (country, path, referer, browser, OS, device type,
#' ...) and returns the top entries by count.
#'
#' @inheritParams cf_rum_page_views
#' @param dimension Character. A dimension name supported by
#'   `rumPageloadEventsAdaptiveGroups`. Common choices:
#'   `"countryName"`, `"requestPath"`, `"refererHost"`,
#'   `"userAgentBrowser"`, `"userAgentOS"`, `"deviceType"`.
#' @param limit Number of rows to return (default 25).
#'
#' @return A data.frame with two columns: the requested
#'   `dimension` and `count`.
#'
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' cf_rum_top(
#'   "acc-1",
#'   site_tag = "abc",
#'   since = Sys.Date() - 7,
#'   until = Sys.Date(),
#'   dimension = "countryName",
#'   limit = 10
#' )
#' }
cf_rum_top <- function(
  account_id,
  site_tag,
  since,
  until,
  dimension = "countryName",
  limit = 25L,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  query <- sprintf(
    "query Top($accountTag: String!, $siteTag: String!,
              $since: Time!, $until: Time!, $limit: Int!) {
      viewer {
        accounts(filter: { accountTag: $accountTag }) {
          rumPageloadEventsAdaptiveGroups(
            limit: $limit,
            filter: {
              siteTag: $siteTag,
              datetime_geq: $since,
              datetime_lt: $until
            },
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
    accountTag = account_id,
    siteTag = site_tag,
    since = format_iso8601(since),
    until = format_iso8601(until),
    limit = limit,
    .token = token,
    .email = email,
    .api_key = api_key,
    .envir = parent.frame()
  )
  groups <- res$data$viewer$accounts[[1]]$rumPageloadEventsAdaptiveGroups
  if (!length(groups)) {
    out <- data.frame(
      .x = character(0),
      count = integer(0),
      stringsAsFactors = FALSE
    )
    names(out)[1] <- dimension
    return(as_cf_tibble(out))
  }
  out <- data.frame(
    .x = vapply(
      groups,
      function(g) as.character(g$dimensions[[dimension]]),
      character(1)
    ),
    count = vapply(groups, function(g) as.integer(g$count), integer(1)),
    stringsAsFactors = FALSE
  )
  names(out)[1] <- dimension
  out <- as_cf_tibble(out)
  out
}
