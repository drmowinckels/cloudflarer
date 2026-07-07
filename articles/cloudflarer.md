# Getting started with cloudflarer

cloudflarer wraps the Cloudflare v4 REST API. Most users will reach for
a handful of named endpoint helpers, but anything not yet wrapped is
reachable through the generic
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)
function.

List endpoints return a data.frame by default (one row per record,
list-columns for nested fields). The data.frames carry the
`tbl_df`/`tbl` classes so callers with the tibble package loaded get
tibble-style printing for free. To get the raw nested list back, pass
`as_df = FALSE`.

## Setup

Set a Cloudflare API token in `~/.Renviron` and restart R:

    CLOUDFLARE_API_TOKEN=your-token-here

The Global API Key (legacy) also works through `CLOUDFLARE_EMAIL` +
`CLOUDFLARE_API_KEY`. See
[`vignette("authentication")`](http://drmowinckels.io/cloudflarer/articles/authentication.md)
for the full setup.

Verify the connection:

``` r

library(cloudflarer)
cf_sitrep()
#> 
#> ── cloudflarer sitrep ──────────────────────────────────────────────────────────
#> ℹ Package version: 0.0.0.9000
#> ✔ Using API token (`CLOUDFLARE_API_TOKEN`).
#> ✔ Credentials verified against the Cloudflare API.
```

## Discovering what you can reach

``` r

cf_user()
#> $id
#> [1] "user-1"
#> 
#> $email
#> [1] "you@example.com"
#> 
#> $first_name
#> [1] "Ada"
#> 
#> $last_name
#> [1] "Lovelace"

cf_list_accounts()
#>       id        name
#> 1 abc123 Example Org
cf_list_zones()
#>       id        name status
#> 1 abc123 example.com active
#> 2 def456 example.org active
```

Both helpers walk every page of results automatically. Pass `max_pages`
to stop early while exploring:

``` r

cf_list_zones(max_pages = 1)
#>       id        name status
#> 1 abc123 example.com active
```

## DNS records

[`cf_list_dns_records()`](http://drmowinckels.io/cloudflarer/reference/cf_list_dns_records.md)
returns a data.frame;
[`cf_get_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_get_dns_record.md),
[`cf_create_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_create_dns_record.md),
[`cf_update_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_update_dns_record.md),
and
[`cf_delete_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_dns_record.md)
cover the CRUD lifecycle:

``` r

zones <- cf_list_zones()
zone_id <- zones$id[1]

records <- cf_list_dns_records(zone_id, type = "A")
head(records[, c("name", "content", "proxied")])
#>               name   content proxied
#> 1      example.com 192.0.2.1    TRUE
#> 2 shop.example.com 192.0.2.2   FALSE

cf_create_dns_record(
  zone_id,
  type    = "A",
  name    = "blog.example.com",
  content = "192.0.2.5",
  proxied = TRUE
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
#> $type
#> [1] "A"
#> 
#> $name
#> [1] "example.com"
#> 
#> $content
#> [1] "192.0.2.99"
#> 
#> $proxied
#> [1] TRUE

cf_delete_dns_record(zone_id, "rec-1")
#> $id
#> [1] "rec-1"
```

## Purging cache

Targeted purges are preferred over wipes:

``` r

cf_purge_cache(zone_id, files = c(
  "https://example.com/index.html",
  "https://example.com/style.css"
))
#> $id
#> [1] "purge-1"

# Or, when you really need to:
cf_purge_cache(zone_id, purge_everything = TRUE)
#> $id
#> [1] "purge-2"
```

## Zone settings

``` r

settings <- cf_get_zone_settings(zone_id)
settings[settings$id %in% c("ssl", "cache_level", "security_level"),
         c("id", "value")]
#>               id      value
#> 1            ssl       full
#> 2    cache_level aggressive
#> 3 security_level     medium

cf_get_zone_setting(zone_id, "ssl")
#> $id
#> [1] "ssl"
#> 
#> $value
#> [1] "full"
#> 
#> $modified_on
#> [1] "2026-05-01T00:00:00Z"
#> 
#> $editable
#> [1] TRUE
```

## Calling endpoints the package does not wrap

Every endpoint in the [Cloudflare API
reference](https://developers.cloudflare.com/api/) is reachable through
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md),
which builds an authenticated request for a path relative to
`/client/v4`. Pipe it through the `httr2` request verbs you need,
perform it, and unwrap the envelope with
[`cf_resp()`](http://drmowinckels.io/cloudflarer/reference/cf_resp.md):

``` r

cf_request("user/tokens/verify") |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "tok-1"
#> 
#> $status
#> [1] "active"

cf_request("zones/abc123/dns_records") |>
  httr2::req_method("POST") |>
  httr2::req_body_json(list(
    type    = "A",
    name    = "www.example.com",
    content = "192.0.2.1",
    proxied = TRUE
  )) |>
  httr2::req_perform() |>
  cf_resp()
#> $id
#> [1] "rec-new"
#> 
#> $type
#> [1] "A"
#> 
#> $name
#> [1] "www.example.com"
#> 
#> $content
#> [1] "192.0.2.1"
#> 
#> $proxied
#> [1] TRUE
```

For paginated list endpoints, pipe the request into
[`cf_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_collect.md)
to get the raw list, then tidy it with
[`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md):

``` r

records <- cf_request("accounts/abc123/access/apps") |>
  cf_collect(per_page = 50)
cf_records_to_df(records)
#>      id               name           domain
#> 1 app-1 Internal Dashboard dash.example.com
```

## Error handling

Both HTTP-level failures and Cloudflare envelope failures
(`success: false`) raise a condition of class `cloudflarer_error`, so
you can catch them with
[`tryCatch()`](https://rdrr.io/r/base/conditions.html):

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
