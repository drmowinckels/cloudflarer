# Package index

## Authentication

Configure and verify Cloudflare credentials (API token or Global API
Key).

- [`cf_auth_mode()`](https://drmowinckels.github.io/cloudflarer/reference/cf_auth_mode.md)
  : Detect which Cloudflare auth mode is configured
- [`cf_has_auth()`](https://drmowinckels.github.io/cloudflarer/reference/cf_has_auth.md)
  : Check whether any Cloudflare credentials are configured
- [`cf_token()`](https://drmowinckels.github.io/cloudflarer/reference/cf_token.md)
  : Cloudflare API token
- [`cf_email()`](https://drmowinckels.github.io/cloudflarer/reference/cf_email.md)
  : Cloudflare account email (legacy auth)
- [`cf_api_key()`](https://drmowinckels.github.io/cloudflarer/reference/cf_api_key.md)
  : Cloudflare Global API Key (legacy auth)
- [`cf_verify()`](https://drmowinckels.github.io/cloudflarer/reference/cf_verify.md)
  [`cf_token_verify()`](https://drmowinckels.github.io/cloudflarer/reference/cf_verify.md)
  : Verify the active Cloudflare credential
- [`cf_sitrep()`](https://drmowinckels.github.io/cloudflarer/reference/cf_sitrep.md)
  : Cloudflare situation report

## Generic requests

Low-level helpers used by every wrapper. Use these directly to call
endpoints the package does not yet provide a function for.

- [`cf_request()`](https://drmowinckels.github.io/cloudflarer/reference/cf_request.md)
  : Perform a generic Cloudflare API request
- [`cf_request_collect()`](https://drmowinckels.github.io/cloudflarer/reference/cf_request_collect.md)
  : Collect every page of a paginated endpoint
- [`cf_graphql()`](https://drmowinckels.github.io/cloudflarer/reference/cf_graphql.md)
  : Run a Cloudflare GraphQL Analytics query

## User

- [`cf_user()`](https://drmowinckels.github.io/cloudflarer/reference/cf_user.md)
  : Get the authenticated user

## Accounts

- [`cf_list_accounts()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_accounts.md)
  : List accounts
- [`cf_get_account()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_account.md)
  : Get a single account

## Zones and zone settings

- [`cf_list_zones()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_zones.md)
  : List zones
- [`cf_get_zone()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone.md)
  : Get a single zone
- [`cf_get_zone_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_settings.md)
  : Get zone settings
- [`cf_get_zone_setting()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_zone_setting.md)
  : Get a single zone setting

## DNS records

- [`cf_list_dns_records()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_dns_records.md)
  : List DNS records in a zone
- [`cf_get_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_dns_record.md)
  : Get a single DNS record
- [`cf_create_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_dns_record.md)
  : Create a DNS record
- [`cf_update_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_dns_record.md)
  : Update a DNS record
- [`cf_delete_dns_record()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_dns_record.md)
  : Delete a DNS record

## Page Rules

- [`cf_list_page_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_page_rules.md)
  : List Page Rules for a zone
- [`cf_get_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_page_rule.md)
  : Get a single Page Rule
- [`cf_create_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_page_rule.md)
  : Create a Page Rule
- [`cf_update_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_update_page_rule.md)
  : Update a Page Rule
- [`cf_delete_page_rule()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_page_rule.md)
  : Delete a Page Rule
- [`cf_page_rule_target()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_target.md)
  : Build a Page Rule URL-match target
- [`cf_page_rule_action()`](https://drmowinckels.github.io/cloudflarer/reference/cf_page_rule_action.md)
  : Build a Page Rule action

## Firewall rules

- [`cf_list_firewall_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_firewall_rules.md)
  : List firewall rules for a zone

## Rulesets

Modern unified rule management (custom rules, transforms, managed
firewall, redirects, cache rules, rate limits).

- [`cf_list_rulesets()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rulesets.md)
  : List Rulesets for a zone
- [`cf_get_ruleset()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_ruleset.md)
  : Get a single zone Ruleset (with its rules)
- [`cf_list_account_rulesets()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_account_rulesets.md)
  : List Rulesets for an account
- [`cf_get_account_ruleset()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_account_ruleset.md)
  : Get a single account Ruleset (with its rules)

## Cache

- [`cf_purge_cache()`](https://drmowinckels.github.io/cloudflarer/reference/cf_purge_cache.md)
  : Purge zone cache

## Workers

- [`cf_list_workers_scripts()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_workers_scripts.md)
  : List Workers scripts in an account
- [`cf_get_workers_script()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_workers_script.md)
  : Get metadata for a single Workers script
- [`cf_workers_invocations()`](https://drmowinckels.github.io/cloudflarer/reference/cf_workers_invocations.md)
  : Workers invocations over time
- [`cf_list_kv_namespaces()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_kv_namespaces.md)
  : List Workers KV namespaces
- [`cf_get_kv_namespace()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_kv_namespace.md)
  : Get a single Workers KV namespace

## Pages

- [`cf_list_pages_projects()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_projects.md)
  : List Cloudflare Pages projects
- [`cf_get_pages_project()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_pages_project.md)
  : Get a single Cloudflare Pages project
- [`cf_list_pages_deployments()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_pages_deployments.md)
  : List deployments for a Pages project

## R2

- [`cf_list_r2_buckets()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_r2_buckets.md)
  : List R2 buckets in an account
- [`cf_get_r2_bucket()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_r2_bucket.md)
  : Get a single R2 bucket

## Turnstile (CAPTCHA replacement)

- [`cf_list_turnstile_widgets()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_turnstile_widgets.md)
  : List Turnstile widgets
- [`cf_get_turnstile_widget()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_turnstile_widget.md)
  : Get a single Turnstile widget
- [`cf_create_turnstile_widget()`](https://drmowinckels.github.io/cloudflarer/reference/cf_create_turnstile_widget.md)
  : Create a Turnstile widget
- [`cf_delete_turnstile_widget()`](https://drmowinckels.github.io/cloudflarer/reference/cf_delete_turnstile_widget.md)
  : Delete a Turnstile widget

## Email Routing

- [`cf_get_email_routing_settings()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_email_routing_settings.md)
  : Email Routing settings for a zone
- [`cf_list_email_routing_rules()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_email_routing_rules.md)
  : List Email Routing rules for a zone
- [`cf_list_email_routing_addresses()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_email_routing_addresses.md)
  : List Email Routing destination addresses

## Tunnels (Zero Trust / cloudflared)

- [`cf_list_tunnels()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_tunnels.md)
  : List Cloudflare Tunnels
- [`cf_get_tunnel()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_tunnel.md)
  : Get a single Cloudflare Tunnel
- [`cf_list_tunnel_connections()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_tunnel_connections.md)
  : List active connections for a Cloudflare Tunnel

## Web Analytics (RUM)

- [`cf_list_rum_sites()`](https://drmowinckels.github.io/cloudflarer/reference/cf_list_rum_sites.md)
  : List Web Analytics (RUM) sites
- [`cf_get_rum_site()`](https://drmowinckels.github.io/cloudflarer/reference/cf_get_rum_site.md)
  : Get a single Web Analytics (RUM) site
- [`cf_rum_page_views()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_page_views.md)
  : Daily page views for a Web Analytics (RUM) site
- [`cf_rum_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_rum_top.md)
  : Top dimensions for a Web Analytics (RUM) site

## GraphQL Analytics convenience

Tidy data.frame wrappers built on top of cf_graphql().

- [`cf_zone_overview()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_overview.md)
  : One-call summary of a zone's recent activity
- [`cf_zone_requests()`](https://drmowinckels.github.io/cloudflarer/reference/cf_zone_requests.md)
  : Daily or hourly HTTP request totals for a zone
- [`cf_cache_ratio()`](https://drmowinckels.github.io/cloudflarer/reference/cf_cache_ratio.md)
  : Daily cache hit ratio for a zone
- [`cf_dns_queries()`](https://drmowinckels.github.io/cloudflarer/reference/cf_dns_queries.md)
  : Daily DNS query counts for a zone
- [`cf_firewall_events_by_day()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_by_day.md)
  : Daily firewall event counts for a zone
- [`cf_firewall_events_top()`](https://drmowinckels.github.io/cloudflarer/reference/cf_firewall_events_top.md)
  : Top firewall events for a zone by a chosen dimension

## Helpers

- [`cf_records_to_df()`](https://drmowinckels.github.io/cloudflarer/reference/cf_records_to_df.md)
  : Convert a list of Cloudflare records to a data.frame
