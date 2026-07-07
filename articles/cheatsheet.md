# cloudflarer cheatsheet

One-page reference of the most-used cloudflarer calls. Every list
endpoint returns a data.frame (with `tbl_df` classes for tibble users);
pass `as_df = FALSE` for the raw nested list.

## Setup

``` r

# In ~/.Renviron
# CLOUDFLARE_API_TOKEN=...                  # recommended
# CLOUDFLARE_EMAIL=you@example.com          # OR (legacy)
# CLOUDFLARE_API_KEY=...

library(cloudflarer)
cf_sitrep()
#> 
#> ── cloudflarer sitrep ──────────────────────────────────────────────────────────
#> ℹ Package version: 0.0.0.9000
#> ✔ Using API token (`CLOUDFLARE_API_TOKEN`).
#> ✔ Credentials verified against the Cloudflare API.
```

## Discover what you can reach

``` r

cf_user()
#> $id
#> [1] "user-1"
#> 
#> $email
#> [1] "you@example.com"
cf_list_accounts()
#>       id        name
#> 1 abc123 Example Org
cf_list_zones()
#>       id        name status
#> 1 abc123 example.com active
cf_list_zones(name = "example.com")
#>       id        name status
#> 1 abc123 example.com active
```

## Quick overview of a zone

``` r

zones <- cf_list_zones()
zone_id    <- zones$id[1]
account_id <- zones$account[[1]]$id

cf_zone_overview(zone_id, account_id = account_id)
#> 
#> ── Zone overview ───────────────────────────────────────────────────────────────
#> ℹ Window: "2026-06-30" to "2026-07-07"
#> 
#> → Requests:        "1,000"
#> → Page views:      "500"
#> → Uniques:         "300"
#> → Bandwidth:       "1.9 MB"
#> → Threats:         "10"
#> → Cache hit (req): "80.0%"
#> → Cache hit (BW):  "75.0%"
#> → DNS queries:     "1,234"
#> → Firewall events: "42"
#> 
#> ℹ Use `$traffic`, `$cache`, `$dns`, `$firewall`, `$top_countries` for per-day breakdowns.
```

[`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md)
pulls traffic, cache ratio, DNS queries, firewall events, and RUM top
countries into one tidy bundle. Each component is wrapped so a missing
permission or Pro-only feature yields `NULL` for that slot instead of
failing the whole call.

## Traffic analytics

``` r

cf_zone_requests(zone_id, Sys.Date() - 7, Sys.Date(), by = "day")
#>         date requests bytes pageviews threats uniques
#> 1 2026-05-01     1000 2e+06       500      10     300
cf_zone_requests(zone_id, Sys.time() - 12 * 3600, Sys.time(), by = "hour")
#>                   date requests bytes pageviews threats uniques
#> 1 2026-05-01T00:00:00Z       50 1e+05        25       1      20

cf_cache_ratio(zone_id, Sys.Date() - 7, Sys.Date())
#>         date requests cached_requests bytes cached_bytes request_hit_ratio
#> 1 2026-05-01     1000             800 2e+06      1500000               0.8
#>   bandwidth_hit_ratio
#> 1                0.75
cf_dns_queries(zone_id, Sys.Date() - 7, Sys.Date())
#>         date queries
#> 1 2026-05-01    1234

# Pro+ only:
cf_firewall_events_by_day(zone_id, Sys.Date() - 7, Sys.Date())
#>         date events
#> 1 2026-05-01     42
cf_firewall_events_top(
  zone_id, Sys.Date() - 7, Sys.Date(),
  dimension = "action", limit = 10
)
#>   action events
#> 1  block     30
```

## Web Analytics (RUM)

``` r

sites <- cf_list_rum_sites(account_id)
site_tag <- sites$site_tag[1]

cf_rum_page_views(account_id, site_tag,
                  since = Sys.Date() - 30, until = Sys.Date())
#>         date pageviews
#> 1 2026-05-01       500

cf_rum_top(account_id, site_tag,
           since = Sys.Date() - 30, until = Sys.Date(),
           dimension = "countryName", limit = 10)
#>     countryName count
#> 1 United States   300
```

## DNS records

``` r

cf_list_dns_records(zone_id, type = "A")
#>      id type        name   content proxied
#> 1 rec-1    A example.com 192.0.2.1    TRUE

cf_create_dns_record(
  zone_id, type = "A", name = "blog",
  content = "192.0.2.5", proxied = TRUE
)
#> $id
#> [1] "rec-new"
#> 
#> $type
#> [1] "A"
#> 
#> $name
#> [1] "blog.example.com"
#> 
#> $content
#> [1] "192.0.2.5"
#> 
#> $proxied
#> [1] TRUE

cf_update_dns_record(zone_id, "rec-1", content = "192.0.2.99")
#> $id
#> [1] "rec-1"
#> 
#> $content
#> [1] "192.0.2.99"
cf_delete_dns_record(zone_id, "rec-1")
#> $id
#> [1] "rec-1"
```

## Page Rules

``` r

cf_list_page_rules(zone_id)
#>       id status targets actions
#> 1 rule-1 active

cf_create_page_rule(
  zone_id,
  targets = list(cf_page_rule_target("*example.com/static/*")),
  actions = list(
    cf_page_rule_action("cache_level", "cache_everything"),
    cf_page_rule_action("edge_cache_ttl", 7200)
  )
)
#> $id
#> [1] "rule-new"
#> 
#> $status
#> [1] "active"

cf_update_page_rule(zone_id, "rule-1", status = "disabled")
#> $id
#> [1] "rule-1"
#> 
#> $status
#> [1] "disabled"
cf_delete_page_rule(zone_id, "rule-1")
#> $id
#> [1] "rule-1"
```

## Cache purging

``` r

cf_purge_cache(zone_id, files = c(
  "https://example.com/index.html",
  "https://example.com/style.css"
))
#> $id
#> [1] "purge-1"

cf_purge_cache(zone_id, prefixes = "example.com/blog")
#> $id
#> [1] "purge-2"

cf_purge_cache(zone_id, purge_everything = TRUE)
#> $id
#> [1] "purge-3"
```

## Zone settings

``` r

cf_get_zone_settings(zone_id)
#>            id      value editable
#> 1         ssl       full     TRUE
#> 2 cache_level aggressive     TRUE
cf_get_zone_setting(zone_id, "ssl")
#> $id
#> [1] "ssl"
#> 
#> $value
#> [1] "full"
#> 
#> $editable
#> [1] TRUE
```

## Email Routing

``` r

cf_get_email_routing_settings(zone_id)
#> $enabled
#> [1] TRUE
#> 
#> $name
#> [1] "example.com"
#> 
#> $status
#> [1] "ready"
cf_list_email_routing_rules(zone_id)
#>     id      name enabled matchers
#> 1 er-1 catch-all    TRUE
cf_list_email_routing_addresses(account_id)
#>       id           email             verified
#> 1 addr-1 you@example.com 2026-05-01T00:00:00Z
```

## Turnstile (CAPTCHA replacement)

``` r

cf_list_turnstile_widgets(account_id)
#>       sitekey         name    mode
#> 1 0x4AAAAAAA1 comment-form managed

cf_create_turnstile_widget(
  account_id,
  name = "comment-form",
  domains = c("example.com", "www.example.com"),
  mode = "managed"
)
#> $sitekey
#> [1] "0x4AAAAAAAnew"
#> 
#> $secret
#> [1] "0x4AAAAAAAsec"
#> 
#> $name
#> [1] "comment-form"
```

## Workers

``` r

cf_list_workers_scripts(account_id)
#>            id
#> 1 hello-world
#> 2     resizer
cf_workers_invocations(account_id, Sys.Date() - 7, Sys.Date())
#>         date      script requests errors subrequests cpu_p50_us cpu_p99_us
#> 1 2026-05-01 hello-world    10000      5        2000        1.2        8.5
cf_list_kv_namespaces(account_id)
#>     id title
#> 1 ns-1 cache
```

## Pages, R2, Tunnels

``` r

cf_list_pages_projects(account_id)
#>       id       name
#> 1 proj-1 my-project
cf_list_pages_deployments(account_id, "my-project")
#>      id environment
#> 1 dep-1  production
cf_list_r2_buckets(account_id)
#>          name location
#> 1 assets-prod     WEUR
cf_list_tunnels(account_id)
#>      id name
#> 1 tun-1 prod
```

## Firewall + Rulesets

``` r

cf_list_firewall_rules(zone_id)
#>     id description filter
#> 1 fw-1  block bots

# Modern rulesets surface:
cf_list_rulesets(zone_id)
#>     id    name kind
#> 1 rs-1 default zone
cf_get_ruleset(zone_id, "rs-1")
#> $id
#> [1] "rs-1"
#> 
#> $name
#> [1] "default"
#> 
#> $rules
#> list()
cf_list_account_rulesets(account_id)
#>         id    name    kind
#> 1 rs-acc-1 managed managed
```

## Escape hatches

For anything cloudflarer does not wrap, drop down to the generics. They
handle auth and the envelope; you handle the path.

``` r

# Any REST endpoint: build -> pipe httr2 verbs -> perform -> unwrap
cf_request("user/tokens/verify") |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "tok-1"
#> 
#> $status
#> [1] "active"
cf_request("zones/abc/dns_records") |>
  httr2::req_method("POST") |>
  httr2::req_body_json(list(type = "A", name = "x", content = "192.0.2.1")) |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "rec-new"
#> 
#> $type
#> [1] "A"
#> 
#> $name
#> [1] "x"
#> 
#> $content
#> [1] "192.0.2.1"

# Paginated REST list (returns a raw list):
cf_request("accounts/abc/access/apps") |> cf_collect(per_page = 50)
#> [[1]]
#> [[1]]$id
#> [1] "app-1"
#> 
#> [[1]]$name
#> [1] "Dashboard"

# Any GraphQL Analytics query:
cf_graphql(
  "query Q($zoneTag: String!) {
    viewer { zones(filter: {zoneTag: $zoneTag}) { httpRequests1dGroups(
      limit: 7,
      filter: { date_geq: \"2026-05-14\", date_lt: \"2026-05-21\" }
    ) { dimensions { date } sum { requests } } } }
  }",
  zoneTag = zone_id
)
#> $data
#> $data$viewer
#> $data$viewer$zones
#> $data$viewer$zones[[1]]
#> $data$viewer$zones[[1]]$httpRequests1dGroups
#> $data$viewer$zones[[1]]$httpRequests1dGroups[[1]]
#> $data$viewer$zones[[1]]$httpRequests1dGroups[[1]]$dimensions
#> $data$viewer$zones[[1]]$httpRequests1dGroups[[1]]$dimensions$date
#> [1] "2026-05-14"
#> 
#> 
#> $data$viewer$zones[[1]]$httpRequests1dGroups[[1]]$sum
#> $data$viewer$zones[[1]]$httpRequests1dGroups[[1]]$sum$requests
#> [1] 1000
```

## Error handling

Every cloudflarer failure (HTTP error, envelope `success: false`,
GraphQL `errors[]`) raises a classed condition:

``` r

tryCatch(
  cf_get_zone("does-not-exist"),
  cloudflarer_error = function(err) {
    message("Cloudflare said: ", conditionMessage(err))
    NULL
  }
)
#> Cloudflare said: Cloudflare API request failed.
#> [7003] Could not route to /zones/does-not-exist, perhaps your object identifier
#> is invalid?
#> NULL
```
