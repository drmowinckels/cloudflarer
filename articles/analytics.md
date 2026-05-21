# Cloudflare website analytics

Cloudflare exposes two analytics surfaces that this package wraps:

| Surface | Best for | Wrapper |
|----|----|----|
| Web Analytics / RUM | Site catalogue (sites with the JavaScript beacon installed) | \[[`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md)\], \[[`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md)\] |
| GraphQL Analytics | Everything else – HTTP requests, bandwidth, page views, uniques, firewall events, Workers, R2, DNS | \[[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)\] |

The legacy REST Zone Analytics endpoints
(`/zones/{id}/analytics/dashboard` and `/analytics/colos`) were retired
by Cloudflare in favour of the GraphQL API, so this package does not
wrap them. Every example below uses GraphQL where the legacy REST call
used to live.

The [GraphQL schema explorer](https://graphql.cloudflare.com/explorer)
is the fastest way to discover the right node, filter, and dimension for
any analytics question.

## Web Analytics (RUM) site catalogue

Cloudflare Web Analytics is the free real-user-monitoring product that
uses a small JavaScript beacon – it works on any site, not just proxied
ones. List the sites configured in an account with:

``` r

accounts <- cf_list_accounts(max_pages = 1)
account_id <- accounts[[1]]$id

sites <- cf_list_rum_sites(account_id)
sites[[1]]$host
sites[[1]]$site_tag

cf_get_rum_site(account_id, sites[[1]]$site_tag)
```

For per-site metrics (page views, visits, country breakdowns, …), query
the GraphQL API with the site’s `site_tag`. See the [Top
countries](#top-countries-for-a-web-analytics-rum-site) example below.

## GraphQL Analytics

\[[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)\]
accepts the query as a string and variables as named `...` arguments.
The full response body is returned, so you access fields under
`$data$...`.

``` r

query <- "
  query Viewer($accountTag: String!) {
    viewer {
      accounts(filter: { accountTag: $accountTag }) {
        accountTag
      }
    }
  }
"
res <- cf_graphql(query, accountTag = account_id)
res$data$viewer$accounts
```

Two things worth knowing about Cloudflare’s GraphQL `viewer`:

- The unfiltered `viewer { accounts { ... } }` query enumerates every
  account the credential might touch and fails with
  `not authorized for that account` if any one of them is out of scope.
  Always supply a `filter` with the `accountTag` you care about.
- The `Account` type only exposes `accountTag`. The human-readable name
  lives on the REST `/accounts` endpoint, which you already have from
  \[[`cf_list_accounts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_accounts.md)\].

### HTTP requests per day for a zone

``` r

zones <- cf_list_zones(max_pages = 1)
zone_id <- zones[[1]]$id

query <- "
  query ZoneRequests($zoneTag: String!, $since: Date!, $until: Date!) {
    viewer {
      zones(filter: { zoneTag: $zoneTag }) {
        httpRequests1dGroups(
          limit: 100,
          filter: { date_geq: $since, date_lt: $until },
          orderBy: [date_ASC]
        ) {
          dimensions { date }
          sum {
            requests
            bytes
            pageViews
            threats
          }
          uniq { uniques }
        }
      }
    }
  }
"

res <- cf_graphql(
  query,
  zoneTag = zone_id,
  since   = format(Sys.Date() - 7, "%Y-%m-%d"),
  until   = format(Sys.Date(),     "%Y-%m-%d")
)

days <- res$data$viewer$zones[[1]]$httpRequests1dGroups
data.frame(
  date     = vapply(days, function(d) d$dimensions$date, character(1)),
  requests = vapply(days, function(d) d$sum$requests,    integer(1)),
  bytes    = vapply(days, function(d) d$sum$bytes,       numeric(1)),
  pageviews = vapply(days, function(d) d$sum$pageViews,  integer(1)),
  uniques  = vapply(days, function(d) d$uniq$uniques,    integer(1))
)
```

`httpRequests1hGroups` (hourly bins) and `httpRequestsAdaptiveGroups`
(sampled adaptive bins) follow the same shape.

### Top countries for a Web Analytics (RUM) site

``` r

query <- "
  query RumByCountry($accountTag: String!, $siteTag: String!,
                     $since: Time!, $until: Time!) {
    viewer {
      accounts(filter: { accountTag: $accountTag }) {
        rumPageloadEventsAdaptiveGroups(
          limit: 25,
          filter: {
            siteTag: $siteTag,
            datetime_geq: $since,
            datetime_lt:  $until
          },
          orderBy: [count_DESC]
        ) {
          count
          dimensions { countryName }
        }
      }
    }
  }
"

res <- cf_graphql(
  query,
  accountTag = account_id,
  siteTag    = sites[[1]]$site_tag,
  since      = format(Sys.Date() - 7, "%Y-%m-%dT00:00:00Z"),
  until      = format(Sys.Date(),     "%Y-%m-%dT00:00:00Z")
)
```

### Error handling

Both REST and GraphQL paths raise a classed `cloudflarer_error` on
failure, so you can wrap calls in
[`tryCatch()`](https://rdrr.io/r/base/conditions.html):

``` r

tryCatch(
  cf_graphql("{ broken }"),
  cloudflarer_error = function(err) {
    message("Cloudflare said: ", conditionMessage(err))
    NULL
  }
)
```

For GraphQL specifically, any non-empty `errors[]` array in the response
is treated as a failure, even when the HTTP status is 200 (which is the
standard GraphQL convention).

## Tidy wrappers

For the most common analytics questions, cloudflarer ships ready-made
data.frame wrappers on top of
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md).
Reach for these first; drop down to
[`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)
only when you need a dimension or filter they do not expose.

### HTTP traffic over time

``` r

cf_zone_requests(zone_id, Sys.Date() - 7, Sys.Date(), by = "day")
cf_zone_requests(zone_id, Sys.time() - 12 * 3600, Sys.time(), by = "hour")
```

### Cache hit ratio

``` r

cf_cache_ratio(zone_id, Sys.Date() - 7, Sys.Date())
```

Columns: `date`, `requests`, `cached_requests`, `bytes`, `cached_bytes`,
`request_hit_ratio`, `bandwidth_hit_ratio`.

### DNS queries

``` r

cf_dns_queries(zone_id, Sys.Date() - 7, Sys.Date())
```

### Firewall events

Available on **Pro, Business, and Enterprise** plans only – the
underlying `firewallEventsAdaptiveGroups` GraphQL node is not exposed on
the Free plan and returns `zone ... does not have access to the path`.

``` r

cf_firewall_events_by_day(zone_id, Sys.Date() - 7, Sys.Date())

cf_firewall_events_top(
  zone_id,
  since = Sys.Date() - 7,
  until = Sys.Date(),
  dimension = "action",
  limit = 10
)
```

Other useful
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md)
dimensions: `"source"`, `"ruleId"`, `"clientCountryName"`,
`"clientRequestPath"`, `"clientRequestHTTPHost"`, `"userAgent"`.

### Real-user (RUM) views

``` r

cf_rum_page_views(account_id, site_tag,
                  since = Sys.Date() - 30, until = Sys.Date())

cf_rum_top(account_id, site_tag,
           since = Sys.Date() - 30, until = Sys.Date(),
           dimension = "countryName", limit = 10)
```

## Picking the right query

- **Counting requests, bandwidth, page views, or uniques over time:**
  [`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)
  (or `httpRequestsAdaptiveGroups` directly via
  [`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)
  for sub-hour granularity).
- **Cache effectiveness:**
  [`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md).
- **DNS query volume:**
  [`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md).
- **Security visibility:**
  [`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md)
  /
  [`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md).
- **RUM page views or unique visitors on a beacon site:**
  [`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md)
  /
  [`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md).
- **Anything else** – Workers invocations, R2 usage, bandwidth by status
  code or hostname, etc.:
  [`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)
  directly. The [GraphQL schema
  explorer](https://graphql.cloudflare.com/explorer) is the fastest way
  to find the right node and dimensions.
