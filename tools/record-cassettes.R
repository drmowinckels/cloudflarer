#!/usr/bin/env Rscript

# Record vcr cassettes for cloudflarer's examples and vignettes.
#
# Run this ONCE, locally, with valid Cloudflare credentials in your
# environment (CLOUDFLARE_API_TOKEN, or CLOUDFLARE_EMAIL +
# CLOUDFLARE_API_KEY). Each documented API call is performed inside a
# named vcr cassette, capturing the real responses to disk. CI and
# `R CMD check` then replay those cassettes offline, so the examples
# and vignettes execute without network access or credentials.
#
#   Rscript tools/record-cassettes.R
#
# Cassettes are written to:
#   inst/_vcr/       replayed by @examples via insert_example_cassette()
#   vignettes/_vcr/  replayed by vignette chunks via setup_knitr()
#
# Real account identifiers are discovered from your account and then
# scrubbed to the stable placeholders the examples/vignettes use
# (see `placeholders` below), so nothing account-specific is written
# to the committed cassettes. Re-run with RECORD="all" to overwrite
# existing cassettes after an API change.
#
# After recording, apply the flip described in tools/RECORDING.md
# (drop `\dontrun{}`/`eval = FALSE`, add the cassette wrappers) and
# commit the cassettes together with those edits.

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

example_dir <- "inst/_vcr"
vignette_dir <- "vignettes/_vcr"
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
  "\nDone. Review the cassettes under ",
  example_dir,
  " and ",
  vignette_dir,
  ", then apply the flip in tools/RECORDING.md."
)
