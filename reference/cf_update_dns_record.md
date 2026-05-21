# Update a DNS record

Performs a `PATCH` on the record, only sending fields supplied as
non-`NULL`. Use a `PUT`-style replace via
[`cf_request()`](http://drmowinckels.io/cloudflarer/reference/cf_request.md)
if you need to overwrite the entire record.

## Usage

``` r
cf_update_dns_record(
  zone_id,
  record_id,
  type = NULL,
  name = NULL,
  content = NULL,
  ttl = NULL,
  proxied = NULL,
  priority = NULL,
  comment = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
)
```

## Arguments

- zone_id:

  Character. Cloudflare zone identifier.

- record_id:

  Character. DNS record identifier.

- type:

  Record type: `"A"`, `"AAAA"`, `"CNAME"`, `"MX"`, `"TXT"`, `"SRV"`,
  etc.

- name:

  Record name (host). For the apex, pass `"@"` or the zone name.

- content:

  Record content. For `A`/`AAAA` an IP address; for `CNAME` a hostname;
  for `TXT` the string value.

- ttl:

  Time to live in seconds. `1` means "automatic" (Cloudflare's default).

- proxied:

  Logical. Whether the record is proxied through Cloudflare. Applies to
  A/AAAA/CNAME.

- priority:

  Integer. Required for `MX` records.

- comment:

  Optional human-readable comment.

- ...:

  Additional fields forwarded to the API for record types with extra
  requirements (`data` for `SRV`, etc.).

- token:

  Character. An API token. If `NULL` (the default), the value of
  `Sys.getenv("CLOUDFLARE_API_TOKEN")` is used.

- email:

  Character. Account email. If `NULL` (the default), reads from the
  `CLOUDFLARE_EMAIL` environment variable.

- api_key:

  Character. The Global API Key. If `NULL` (the default), reads from the
  `CLOUDFLARE_API_KEY` environment variable.

## Value

A named list describing the updated record.

## See also

Other dns:
[`cf_create_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_create_dns_record.md),
[`cf_delete_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_delete_dns_record.md),
[`cf_get_dns_record()`](http://drmowinckels.io/cloudflarer/reference/cf_get_dns_record.md),
[`cf_list_dns_records()`](http://drmowinckels.io/cloudflarer/reference/cf_list_dns_records.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cf_update_dns_record("zone-1", "rec-1", content = "192.0.2.2")
} # }
```
