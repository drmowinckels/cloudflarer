#!/usr/bin/env Rscript

# OPTIONAL live cassette recorder for cloudflarer.
#
# The cassettes committed under inst/_vcr/ and vignettes/_vcr/ are
# hand-authored with SYNTHETIC data (example.com, 192.0.2.x) so no real
# account data ever ships. You do NOT need to run this script to build,
# check, or develop the package.
#
# Run it only if you want real recorded fixtures as a starting point.
# It records against your live account into a scratch directory
# (tools/_recorded/, git-ignored) and NEVER touches the committed
# cassettes. Recorded responses contain REAL account data -- zone names,
# DNS records, IP addresses, and Email Routing destination ADDRESSES
# (PII). You MUST scrub every real value to a synthetic placeholder
# before copying anything into inst/_vcr/ or vignettes/_vcr/. See
# tools/RECORDING.md.
#
#   Rscript tools/record-cassettes.R
#
# Needs valid credentials in the environment (CLOUDFLARE_API_TOKEN, or
# CLOUDFLARE_EMAIL + CLOUDFLARE_API_KEY).

record <- Sys.getenv("RECORD", unset = "once")

suppressMessages({
  library(cloudflarer)
  library(vcr)
})

if (!cf_has_auth()) {
  stop(
    "No Cloudflare credentials found. Set CLOUDFLARE_API_TOKEN (or ",
    "CLOUDFLARE_EMAIL + CLOUDFLARE_API_KEY) before recording.",
    call. = FALSE
  )
}

message(
  "WARNING: recording against your LIVE account. Output goes to ",
  "tools/_recorded/ and contains real data (zone names, DNS, IPs, ",
  "Email Routing addresses / PII). Scrub before copying into the ",
  "committed inst/_vcr or vignettes/_vcr cassettes."
)

# Scratch output only: never write into the committed synthetic cassettes.
example_dir <- "tools/_recorded/inst"
vignette_dir <- "tools/_recorded/vignettes"
dir.create(example_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(vignette_dir, showWarnings = FALSE, recursive = TRUE)

# Discover real identifiers to exercise the endpoints, then map each to
# the placeholder its example/vignette uses so the committed cassettes
# stay account-agnostic and still match on replay.
message("Discovering account resources ...")
accounts <- cf_list_accounts(as_df = FALSE)
zones <- cf_list_zones(as_df = FALSE)
if (!length(accounts) || !length(zones)) {
  stop("Need at least one account and one zone to record cassettes.")
}
account_id <- accounts[[1]]$id
zone_id <- zones[[1]]$id

placeholders <- list(
  "abc123" = zone_id,
  "acc-1" = account_id
)

vcr_configure(
  dir = example_dir,
  match_requests_on = c("method", "uri"),
  filter_request_headers = c(
    "Authorization",
    "X-Auth-Email",
    "X-Auth-Key"
  ),
  filter_sensitive_data = c(
    placeholders,
    list(
      "<<TOKEN>>" = Sys.getenv("CLOUDFLARE_API_TOKEN"),
      "<<EMAIL>>" = Sys.getenv("CLOUDFLARE_EMAIL"),
      "<<APIKEY>>" = Sys.getenv("CLOUDFLARE_API_KEY")
    )
  )
)

# A cassette entry: `name` is the file stem, `dir` selects examples vs
# vignettes, and `code` is the call(s) to capture. Add one row per
# example / vignette chunk that performs HTTP. `id` maps to the real
# identifier at record time and to the placeholder on replay.
cassette <- function(name, code, dir = example_dir) {
  message("Recording ", basename(dir), "/", name, ".yml")
  vcr::use_cassette(name, code, dir = dir, record = record)
  invisible(NULL)
}

# ---- Example cassettes (inst/_vcr) -----------------------------------

cassette("cf_user", cf_user())
cassette("cf_verify", cf_verify())
cassette("cf_sitrep", cf_sitrep())

cassette("cf_list_accounts", cf_list_accounts())
cassette("cf_get_account", cf_get_account(account_id))

cassette("cf_list_zones", cf_list_zones())
cassette("cf_get_zone", cf_get_zone(zone_id))
cassette("cf_get_zone_settings", cf_get_zone_settings(zone_id))
cassette("cf_get_zone_setting", cf_get_zone_setting(zone_id, "ssl"))

cassette("cf_list_dns_records", cf_list_dns_records(zone_id))
cassette("cf_list_rulesets", cf_list_rulesets(zone_id))
cassette("cf_list_firewall_rules", cf_list_firewall_rules(zone_id))
cassette("cf_list_page_rules", cf_list_page_rules(zone_id))

cassette("cf_list_r2_buckets", cf_list_r2_buckets(account_id))
cassette("cf_list_workers_scripts", cf_list_workers_scripts(account_id))
cassette("cf_list_kv_namespaces", cf_list_kv_namespaces(account_id))
cassette("cf_list_pages_projects", cf_list_pages_projects(account_id))
cassette("cf_list_tunnels", cf_list_tunnels(account_id))
cassette("cf_list_turnstile_widgets", cf_list_turnstile_widgets(account_id))
cassette("cf_list_account_rulesets", cf_list_account_rulesets(account_id))

cassette(
  "cf_list_email_routing_addresses",
  cf_list_email_routing_addresses(account_id)
)
cassette(
  "cf_get_email_routing_settings",
  cf_get_email_routing_settings(zone_id)
)
cassette(
  "cf_list_email_routing_rules",
  cf_list_email_routing_rules(zone_id)
)

# ---- Vignette cassettes (vignettes/_vcr) -----------------------------
# Cassette names must match the `cassette` chunk option in the vignette.

cassette("intro-sitrep", cf_sitrep(), dir = vignette_dir)
cassette(
  "intro-discover",
  {
    cf_user()
    cf_list_accounts()
    cf_list_zones()
  },
  dir = vignette_dir
)
cassette(
  "intro-zones-page",
  cf_list_zones(max_pages = 1),
  dir = vignette_dir
)
cassette(
  "intro-dns-list",
  cf_list_dns_records(zone_id, type = "A"),
  dir = vignette_dir
)
cassette(
  "intro-settings",
  {
    cf_get_zone_settings(zone_id)
    cf_get_zone_setting(zone_id, "ssl")
  },
  dir = vignette_dir
)
cassette(
  "intro-generic",
  {
    cf_request("user/tokens/verify") |>
      httr2::req_perform() |>
      cf_resp()
  },
  dir = vignette_dir
)

message(
  "\nDone. Recorded to ",
  example_dir,
  " and ",
  vignette_dir,
  ". SCRUB all real account data to synthetic placeholders before ",
  "copying any cassette into inst/_vcr or vignettes/_vcr. See ",
  "tools/RECORDING.md."
)
