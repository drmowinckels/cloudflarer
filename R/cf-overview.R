#' One-call summary of a zone's recent activity
#'
#' Bundles the most-used analytics endpoints into a single call
#' and returns a named list of tidy data.frames covering traffic,
#' cache effectiveness, DNS queries, firewall events, and (when
#' `site_tag` is supplied) Web Analytics top countries.
#'
#' Each underlying call is wrapped in `tryCatch()`, so an
#' individual failure (Free-plan gating, missing permission,
#' empty data) yields `NULL` for that component instead of
#' aborting the whole overview.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param since,until Date or `POSIXct`. Half-open `[since, until)`.
#'   Defaults to the last 7 days.
#' @param account_id Optional account identifier. Required for the
#'   `top_countries` slot.
#' @param site_tag Optional Web Analytics site tag. Required for
#'   the `top_countries` slot.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with class `cloudflarer_overview`:
#'   * `traffic` -- daily requests, bytes, page views, threats,
#'     uniques (from [cf_zone_requests()]).
#'   * `cache` -- daily cache hit ratios (from [cf_cache_ratio()]).
#'   * `dns` -- daily DNS query counts (from [cf_dns_queries()]).
#'   * `firewall` -- daily firewall event counts (from
#'     [cf_firewall_events_by_day()]; Pro+ plans only).
#'   * `top_countries` -- top countries by RUM page views (from
#'     [cf_rum_top()]); only populated when `account_id` and
#'     `site_tag` are supplied.
#'   * `summary` -- a one-row data.frame with the period totals.
#'
#' @export
#' @family analytics
#' @examples
#' \dontrun{
#' ov <- cf_zone_overview(zone_id, account_id = account_id, site_tag = site_tag)
#' ov$traffic
#' ov$summary
#' }
cf_zone_overview <- function(
  zone_id,
  since = Sys.Date() - 7,
  until = Sys.Date(),
  account_id = NULL,
  site_tag = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  safe <- function(expr) {
    tryCatch(expr, cloudflarer_error = function(e) NULL)
  }

  traffic <- safe(cf_zone_requests(
    zone_id,
    since,
    until,
    by = "day",
    token = token,
    email = email,
    api_key = api_key
  ))
  cache <- safe(cf_cache_ratio(
    zone_id,
    since,
    until,
    token = token,
    email = email,
    api_key = api_key
  ))
  dns <- safe(cf_dns_queries(
    zone_id,
    since,
    until,
    token = token,
    email = email,
    api_key = api_key
  ))
  firewall <- safe(cf_firewall_events_by_day(
    zone_id,
    since,
    until,
    token = token,
    email = email,
    api_key = api_key
  ))

  top_countries <- NULL
  if (!is.null(account_id) && !is.null(site_tag)) {
    top_countries <- safe(cf_rum_top(
      account_id,
      site_tag,
      since,
      until,
      dimension = "countryName",
      token = token,
      email = email,
      api_key = api_key
    ))
  }

  summary_df <- overview_summary(traffic, cache, dns, firewall, since, until)

  structure(
    list(
      traffic = traffic,
      cache = cache,
      dns = dns,
      firewall = firewall,
      top_countries = top_countries,
      summary = summary_df
    ),
    class = c("cloudflarer_overview", "list"),
    since = since,
    until = until,
    zone_id = zone_id
  )
}

overview_summary <- function(traffic, cache, dns, firewall, since, until) {
  totals <- function(x, col) {
    if (is.null(x) || !nrow(x)) NA_real_ else sum(x[[col]], na.rm = TRUE)
  }
  ratio <- function(x, num, den) {
    if (is.null(x) || !nrow(x)) {
      return(NA_real_)
    }
    d <- sum(x[[den]], na.rm = TRUE)
    if (d == 0) NA_real_ else sum(x[[num]], na.rm = TRUE) / d
  }
  as_cf_tibble(data.frame(
    since = as.character(since),
    until = as.character(until),
    requests = totals(traffic, "requests"),
    bytes = totals(traffic, "bytes"),
    pageviews = totals(traffic, "pageviews"),
    uniques = totals(traffic, "uniques"),
    threats = totals(traffic, "threats"),
    cache_hit_ratio = ratio(cache, "cached_requests", "requests"),
    bandwidth_hit_ratio = ratio(cache, "cached_bytes", "bytes"),
    dns_queries = totals(dns, "queries"),
    firewall_events = totals(firewall, "events"),
    stringsAsFactors = FALSE
  ))
}

#' @export
print.cloudflarer_overview <- function(x, ...) {
  s <- x$summary
  cli::cli_h1("Zone overview")
  cli::cli_alert_info("Window: {.val {s$since}} to {.val {s$until}}")
  cli::cli_text("")
  cli::cli_alert("Requests:        {.val {format(s$requests, big.mark = ',')}}")
  cli::cli_alert(
    "Page views:      {.val {format(s$pageviews, big.mark = ',')}}"
  )
  cli::cli_alert("Uniques:         {.val {format(s$uniques, big.mark = ',')}}")
  cli::cli_alert(
    "Bandwidth:       {.val {sprintf('%.1f MB', s$bytes / 1024^2)}}"
  )
  cli::cli_alert("Threats:         {.val {format(s$threats, big.mark = ',')}}")
  cli::cli_alert(
    "Cache hit (req): {.val {sprintf('%.1f%%', 100 * s$cache_hit_ratio)}}"
  )
  cli::cli_alert(
    "Cache hit (BW):  {.val {sprintf('%.1f%%', 100 * s$bandwidth_hit_ratio)}}"
  )
  cli::cli_alert(
    "DNS queries:     {.val {format(s$dns_queries, big.mark = ',')}}"
  )
  if (!is.na(s$firewall_events)) {
    cli::cli_alert(
      "Firewall events: {.val {format(s$firewall_events, big.mark = ',')}}"
    )
  } else {
    cli::cli_alert(
      "Firewall events: {.emph not available (Pro+ feature)}"
    )
  }
  if (!is.null(x$top_countries) && nrow(x$top_countries)) {
    cli::cli_h2("Top countries (RUM)")
    top_rows <- utils::head(x$top_countries, 5)
    label_col <- setdiff(names(top_rows), "count")[1]
    for (i in seq_len(nrow(top_rows))) {
      cli::cli_alert(sprintf(
        "  %s: %s",
        top_rows[[label_col]][i],
        format(top_rows$count[i], big.mark = ",")
      ))
    }
  }
  cli::cli_text("")
  cli::cli_alert_info(paste(
    "Use {.code $traffic}, {.code $cache}, {.code $dns},",
    "{.code $firewall}, {.code $top_countries} for per-day breakdowns."
  ))
  invisible(x)
}
