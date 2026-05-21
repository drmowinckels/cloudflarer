# Run a Cloudflare GraphQL Analytics query

Cloudflare's [Analytics GraphQL
API](https://developers.cloudflare.com/analytics/graphql-api/) exposes
most current and historical analytics datasets (HTTP requests, DNS,
firewall, Workers, R2, etc.) behind a single endpoint: `POST /graphql`.
The response shape is the standard GraphQL `{data, errors}` envelope,
not Cloudflare's REST envelope, so this function is a separate path from
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md).

## Usage

``` r
cf_graphql(
  query,
  ...,
  .operation_name = NULL,
  .token = NULL,
  .email = NULL,
  .api_key = NULL,
  .envir = parent.frame()
)
```

## Arguments

- query:

  Character. A GraphQL query string.

- ...:

  Named GraphQL variables. For example
  `cf_graphql(query, zoneTag = "abc", limit = 10)`.

- .operation_name:

  Optional operation name when the query contains multiple operations.

- .token, .email, .api_key:

  Optional per-call credentials. Dot-prefixed to avoid clashing with
  GraphQL variable names. See
  [`cf_token()`](http://drmowinckels.io/cloudflarer/reference/cf_token.md),
  [`cf_email()`](http://drmowinckels.io/cloudflarer/reference/cf_email.md),
  [`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md).

- .envir:

  Environment for error reporting. Defaults to the caller, so error
  messages point at the user's code.

## Value

The parsed response body, including `data` and (when present)
`extensions`. Any non-empty `errors` array raises a classed
`cloudflarer_error`.

## Details

Variables are passed through `...` as named arguments, the same pattern
used by the meetupr package. All values must be named; an unnamed value
raises an error before the request is made.

## See also

Other analytics:
[`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
[`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
[`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
[`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md),
[`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md),
[`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
[`cf_rum_page_views()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_page_views.md),
[`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md),
[`cf_workers_invocations()`](http://drmowinckels.io/cloudflarer/reference/cf_workers_invocations.md),
[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md),
[`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md)

## Examples

``` r
if (FALSE) { # \dontrun{
res <- cf_graphql(
  "query Viewer($accountTag: String!) {
     viewer {
       accounts(filter: { accountTag: $accountTag }) {
         accountTag
       }
     }
   }",
  accountTag = "abc123"
)
res$data$viewer$accounts

res <- cf_graphql(
  "
  query ZoneRequests($zoneTag: String!, $since: Date!, $until: Date!) {
    viewer {
      zones(filter: { zoneTag: $zoneTag }) {
        httpRequests1dGroups(
          limit: 100,
          filter: { date_geq: $since, date_lt: $until }
        ) {
          dimensions { date }
          sum { requests bytes pageViews }
          uniq { uniques }
        }
      }
    }
  }
  ",
  zoneTag = "abc123",
  since = "2026-05-01",
  until = "2026-05-08"
)
} # }
```
