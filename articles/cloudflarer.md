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
```

## Discovering what you can reach

``` r

cf_user()

cf_list_accounts()
cf_list_zones()
```

Both helpers walk every page of results automatically. Pass `max_pages`
to stop early while exploring:

``` r

cf_list_zones(max_pages = 1)
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

cf_create_dns_record(
  zone_id,
  type    = "A",
  name    = "blog.example.com",
  content = "192.0.2.5",
  proxied = TRUE
)

cf_update_dns_record(zone_id, "rec-1", content = "192.0.2.99")

cf_delete_dns_record(zone_id, "rec-1")
```

## Purging cache

Targeted purges are preferred over wipes:

``` r

cf_purge_cache(zone_id, files = c(
  "https://example.com/index.html",
  "https://example.com/style.css"
))

# Or, when you really need to:
cf_purge_cache(zone_id, purge_everything = TRUE)
```

## Zone settings

``` r

settings <- cf_get_zone_settings(zone_id)
settings[settings$id %in% c("ssl", "cache_level", "security_level"),
         c("id", "value")]

cf_get_zone_setting(zone_id, "ssl")
```

## Calling endpoints the package does not wrap

Every endpoint in the [Cloudflare API
reference](https://developers.cloudflare.com/api/) is reachable through
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md).
Pass the path relative to `/client/v4`, an HTTP `method`, and optional
`query` or `body` lists.

``` r

cf_request("user/tokens/verify")

cf_request(
  "zones/abc123/dns_records",
  method = "POST",
  body = list(
    type    = "A",
    name    = "www.example.com",
    content = "192.0.2.1",
    proxied = TRUE
  )
)
```

For paginated list endpoints, use
[`cf_request_collect()`](http://drmowinckels.io/cloudflarer/reference/cf_request_collect.md)
to get the raw list, or call
[`cf_records_to_df()`](http://drmowinckels.io/cloudflarer/reference/cf_records_to_df.md)
on the result yourself to tidy it into a data.frame:

``` r

records <- cf_request_collect(
  "accounts/abc123/access/apps",
  per_page = 50
)
cf_records_to_df(records)
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
```
