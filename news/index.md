# Changelog

## cloudflarer 0.0.0.9000

- Initial scaffold of the package.

### Hardening

- [`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md)
  no longer crashes with an `NA`-in-`if` error when no credentials are
  configured. It now falls through to `/user` so the underlying
  credential helpers raise the documented “No Cloudflare credentials
  found” message.
- [`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md)
  honours the same credential precedence as the request layer:
  explicitly-passed `email`/`api_key` now verify against `/user` even
  when a `CLOUDFLARE_API_TOKEN` is present in the environment, instead
  of silently verifying the env token.
- [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md)
  no longer silently truncates numeric data when records mix integer and
  double values for the same field. Mixed `integer + double` columns
  widen to `double`; otherwise incompatible mixed scalar types fall back
  to a list-column. Classed scalar values (`Date`, `POSIXct`) are kept
  in a list-column rather than being stripped to bare numerics.
- [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md)
  validates that `records` is a list of named lists and aborts with a
  clear message otherwise.
- [`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md)
  now only swallows `cloudflarer_error` conditions per its documented
  contract. Programmer errors and other unexpected exceptions propagate
  instead of being silently reduced to `NULL`.
- Every endpoint wrapper that interpolates an identifier into a URL path
  now validates the identifier via the new internal `cf_check_id()`
  helper, replacing confusing API or routing errors with a single useful
  message.
- Boolean Cloudflare query parameters are now serialized consistently
  through an internal `cf_query_bool()` helper, and boolean flags that
  are only sent when `TRUE` (for example `enabled_only`,
  `verified_only`) are validated up front through the shared
  `cf_check_flag()` helper so bad input raises the same clear,
  argument-named message everywhere.
- Endpoint wrappers no longer assemble request paths with
  [`paste0()`](https://rdrr.io/r/base/paste.html). Each wrapper passes
  its path as a character vector of segments
  (`c("zones", zone_id, "dns_records")`) that is appended through
  [`httr2::req_url_path_append()`](https://httr2.r-lib.org/reference/req_url.html),
  so every segment is URL-encoded by `httr2` rather than
  string-concatenated.
- `format_graphql_error()` escapes braces after assembling the full
  message, so a brace appearing in the GraphQL `path` segment can no
  longer confuse `cli`’s interpolation.
- Response-envelope access uses `[["result"]]` instead of `$result`,
  avoiding R’s partial name matching against `result_info` on the
  unusual case where an envelope omits `result`.
- The legacy Global API Key auth path (`X-Auth-Email`/ `X-Auth-Key`) now
  redacts both headers via
  [`httr2::req_headers_redacted()`](https://httr2.r-lib.org/reference/req_headers.html),
  matching the protection `cf_req_auth()` already gave bearer tokens.
  Previously, printing or dry-running a request built with email + key
  credentials leaked the Global API Key in plain text.
- [`cf_firewall_events_top()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_top.md)
  and
  [`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md)
  validate `dimension` through the new internal
  `cf_check_dimension_name()` helper before splicing it into the
  underlying GraphQL query. `dimension` must be a single GraphQL field
  name and cannot collide with the fixed metric column
  (`events`/`count`); previously an unvalidated `dimension` was
  interpolated verbatim into the query text, so a caller-controlled
  value (for example one forwarded from a Shiny input by code built on
  top of this package) could break out of the intended selection set and
  request additional fields.
- **Breaking:**
  [`cf_zone_overview()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_overview.md)
  now returns `zone_id`, `since`, and `until` as ordinary list elements
  instead of object attributes, so they’re accessed the same way as
  every other component (`ov$zone_id` rather than
  `attr(ov, "zone_id")`).

### Core

- Composable request layer built on `httr2`.
  [`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)
  builds an authenticated request for an endpoint and returns it;
  callers pipe on the `httr2` verbs they need (`req_method()`,
  `req_url_query()`, `req_body_json()`), perform it, and unwrap the
  Cloudflare envelope with
  [`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md).
  [`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md)
  walks a paginated list endpoint from such a request. This lets users
  mix the package’s helpers with plain `httr2` to call anything the
  package does not wrap, instead of routing everything through one
  argument-heavy function.
- Two-mode authentication: API token via `CLOUDFLARE_API_TOKEN`, or
  legacy Global API Key via `CLOUDFLARE_EMAIL` + `CLOUDFLARE_API_KEY`.
  The active mode is reported by
  [`cf_auth_mode()`](http://drmowinckels.io/cloudflarer/reference/cf_auth_mode.md).
- Authentication helpers:
  [`cf_token()`](http://drmowinckels.io/cloudflarer/reference/cf_token.md),
  [`cf_email()`](http://drmowinckels.io/cloudflarer/reference/cf_email.md),
  [`cf_api_key()`](http://drmowinckels.io/cloudflarer/reference/cf_api_key.md),
  [`cf_has_auth()`](http://drmowinckels.io/cloudflarer/reference/cf_has_auth.md),
  [`cf_token_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md),
  [`cf_verify()`](http://drmowinckels.io/cloudflarer/reference/cf_verify.md).
- Diagnostic helper
  [`cf_sitrep()`](http://drmowinckels.io/cloudflarer/reference/cf_sitrep.md)
  reports the active mode and verifies the configured credentials
  against the live API.
- All REST API failures that reach the API, whether HTTP-level or
  envelope-level (`success: false`), raise a classed `cloudflarer_error`
  condition that can be caught with
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html).
  Transport-level failures (DNS, connection refused, timeout) surface as
  the underlying `httr2` error.

### Data frame defaults

- List endpoints
  ([`cf_list_accounts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_accounts.md),
  [`cf_list_zones()`](http://drmowinckels.io/cloudflarer/reference/cf_list_zones.md),
  [`cf_list_dns_records()`](http://drmowinckels.io/cloudflarer/reference/cf_list_dns_records.md),
  [`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
  [`cf_get_zone_settings()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone_settings.md))
  return a data.frame by default via the new
  [`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md)
  helper. Scalar fields become typed columns; vector or nested fields
  are kept as list-columns. Pass `as_df = FALSE` to get the raw nested
  list back.
- Returned data.frames carry the `tbl_df`/`tbl` classes so callers with
  the tibble package loaded see tibble-style printing automatically;
  users without tibble simply see a data.frame.

### REST endpoints

- [`cf_user()`](http://drmowinckels.io/cloudflarer/reference/cf_user.md).
- Accounts:
  [`cf_list_accounts()`](http://drmowinckels.io/cloudflarer/reference/cf_list_accounts.md),
  [`cf_get_account()`](http://drmowinckels.io/cloudflarer/reference/cf_get_account.md).
- Zones:
  [`cf_list_zones()`](http://drmowinckels.io/cloudflarer/reference/cf_list_zones.md),
  [`cf_get_zone()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone.md),
  [`cf_get_zone_settings()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone_settings.md),
  [`cf_get_zone_setting()`](http://drmowinckels.io/cloudflarer/reference/cf_get_zone_setting.md).
- DNS records:
  [`cf_list_dns_records()`](http://drmowinckels.io/cloudflarer/reference/cf_list_dns_records.md),
  [`cf_get_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_get_dns_record.md),
  [`cf_create_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_create_dns_record.md),
  [`cf_update_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_update_dns_record.md),
  [`cf_delete_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_dns_record.md).
- Cache:
  [`cf_purge_cache()`](http://drmowinckels.io/cloudflarer/reference/cf_purge_cache.md)
  for targeted (`files`, `hosts`, `prefixes`, `tags`) or whole-zone
  (`purge_everything = TRUE`) invalidations.
- Page Rules:
  [`cf_list_page_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_page_rules.md),
  [`cf_get_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_get_page_rule.md),
  [`cf_create_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_create_page_rule.md),
  [`cf_update_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_update_page_rule.md),
  [`cf_delete_page_rule()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_page_rule.md),
  plus the constructor helpers
  [`cf_page_rule_target()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_target.md)
  and
  [`cf_page_rule_action()`](http://drmowinckels.io/cloudflarer/reference/cf_page_rule_action.md).
- Firewall rules (classic expression-based custom rules):
  [`cf_list_firewall_rules()`](http://drmowinckels.io/cloudflarer/reference/cf_list_firewall_rules.md).
- Rulesets API (modern unified rule management):
  [`cf_list_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rulesets.md),
  [`cf_get_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_ruleset.md),
  [`cf_list_account_rulesets()`](http://drmowinckels.io/cloudflarer/reference/cf_list_account_rulesets.md),
  [`cf_get_account_ruleset()`](http://drmowinckels.io/cloudflarer/reference/cf_get_account_ruleset.md).
- DNS query counts:
  [`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md)
  returns daily query totals for a zone via the GraphQL
  `dnsAnalyticsAdaptiveGroups` node (requires `Account Analytics: Read`
  or the Global API Key).

### Analytics

- Web Analytics (RUM) site catalogue:
  [`cf_list_rum_sites()`](http://drmowinckels.io/cloudflarer/reference/cf_list_rum_sites.md),
  [`cf_get_rum_site()`](http://drmowinckels.io/cloudflarer/reference/cf_get_rum_site.md).
- [`cf_graphql()`](http://drmowinckels.io/cloudflarer/reference/cf_graphql.md)
  is a generic GraphQL client for Cloudflare’s Analytics GraphQL API.
  Variables are passed as named `...` arguments. The full response body
  is returned (so callers access `$data$...`); non-empty `errors[]`
  raise a classed `cloudflarer_error`.
- Tidy GraphQL wrappers returning data.frames:
  - `cf_zone_requests(zone_id, since, until, by = "day"|"hour")` – one
    row per time bin with `requests`, `bytes`, `pageviews`, `threats`,
    `uniques`.
  - `cf_cache_ratio(zone_id, since, until)` – daily cache hit ratios for
    requests and bandwidth.
  - `cf_dns_queries(zone_id, since, until)` – daily DNS query counts
    (`queries`, `uncached_queries`, `stale_queries`).
  - `cf_firewall_events_by_day(zone_id, since, until)` – daily firewall
    event counts.
  - `cf_firewall_events_top(zone_id, since, until, dimension, limit)` –
    top firewall events by `action`, `source`, `ruleId`,
    `clientCountryName`, `clientRequestPath`, …
  - `cf_rum_page_views(account_id, site_tag, since, until)` – daily
    page-view totals for a Web Analytics site.
  - `cf_rum_top(account_id, site_tag, since, until, dimension, limit)` –
    top entries by any RUM dimension (`countryName`, `requestPath`,
    `userAgentBrowser`, …).
- The legacy REST Zone Analytics endpoints
  (`/zones/{id}/analytics/dashboard`, `.../analytics/colos`) are not
  wrapped because Cloudflare retired them in favour of the GraphQL API.

### Workers

- `cf_list_workers_scripts(account_id)`,
  `cf_get_workers_script(account_id, script_name)`.
- `cf_workers_invocations(account_id, since, until, script_name = NULL)`
  returns a tidy data.frame with one row per day per script: `requests`,
  `errors`, `subrequests`, `cpu_p50_us`, `cpu_p99_us`.
- KV namespaces: `cf_list_kv_namespaces(account_id)`,
  `cf_get_kv_namespace(account_id, namespace_id)`.

### Pages

- `cf_list_pages_projects(account_id)`,
  `cf_get_pages_project(account_id, project_name)`,
  `cf_list_pages_deployments(account_id, project_name)`.

### R2

- `cf_list_r2_buckets(account_id)`,
  `cf_get_r2_bucket(account_id, bucket_name)`.

### Turnstile

- `cf_list_turnstile_widgets(account_id)`,
  `cf_get_turnstile_widget(account_id, sitekey)`.
- `cf_create_turnstile_widget(account_id, name, domains, mode, bot_fight_mode, region)`
  returns the sitekey and (one-shot) secret.
- `cf_delete_turnstile_widget(account_id, sitekey)`.

### Email Routing

- `cf_get_email_routing_settings(zone_id)` returns the routing state for
  a zone.
- `cf_list_email_routing_rules(zone_id, enabled_only = FALSE)`.
- `cf_list_email_routing_addresses(account_id, verified_only = FALSE)`
  lists destination addresses (which are account-scoped, not
  zone-scoped).

### Tunnels (Zero Trust / cloudflared)

- `cf_list_tunnels(account_id, is_deleted = FALSE)`,
  `cf_get_tunnel(account_id, tunnel_id)`,
  `cf_list_tunnel_connections(account_id, tunnel_id)`.

### Overview composite

- `cf_zone_overview(zone_id, since, until, account_id, site_tag)`
  bundles
  [`cf_zone_requests()`](http://drmowinckels.io/cloudflarer/reference/cf_zone_requests.md),
  [`cf_cache_ratio()`](http://drmowinckels.io/cloudflarer/reference/cf_cache_ratio.md),
  [`cf_dns_queries()`](http://drmowinckels.io/cloudflarer/reference/cf_dns_queries.md),
  [`cf_firewall_events_by_day()`](http://drmowinckels.io/cloudflarer/reference/cf_firewall_events_by_day.md),
  and (when `account_id` + `site_tag` are supplied)
  [`cf_rum_top()`](http://drmowinckels.io/cloudflarer/reference/cf_rum_top.md)
  into a single named list, with a one-row `summary` covering the
  window. Each underlying call is wrapped in
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html) so an
  individual failure (Free-plan gating, missing permission) yields
  `NULL` for that slot instead of aborting the whole overview. Carries
  an S3 [`print()`](https://rdrr.io/r/base/print.html) method that
  renders a one-line-per-metric report via `cli`.

### Documentation

- New cheatsheet vignette
  ([`vignette("cheatsheet")`](http://drmowinckels.io/cloudflarer/articles/cheatsheet.md))
  – a single page of copy-pasteable patterns for every endpoint surface
  in the package.
