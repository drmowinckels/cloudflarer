#' List DNS records in a zone
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param type Optional record type filter, for example `"A"` or
#'   `"CNAME"`.
#' @param name Optional record name filter.
#' @param per_page Page size, see [cf_collect()].
#' @param max_pages Maximum pages to retrieve, see
#'   [cf_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of DNS records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family dns
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_dns_records", package = "cloudflarer")
#' }
#' cf_list_dns_records("abc123")
#' cf_list_dns_records("abc123", type = "A")
#' \dontshow{vcr::eject_cassette()}
cf_list_dns_records <- function(
  zone_id,
  type = NULL,
  name = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  records <- cf_request(
    c("zones", zone_id, "dns_records"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_url_query(type = type, name = name) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single DNS record
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param record_id Character. DNS record identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the record.
#' @export
#' @family dns
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_dns_record", package = "cloudflarer")
#' }
#' cf_get_dns_record("zone-1", "rec-1")
#' \dontshow{vcr::eject_cassette()}
cf_get_dns_record <- function(
  zone_id,
  record_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(record_id)
  cf_request(
    c("zones", zone_id, "dns_records", record_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Create a DNS record
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param type Record type: `"A"`, `"AAAA"`, `"CNAME"`, `"MX"`,
#'   `"TXT"`, `"SRV"`, etc.
#' @param name Record name (host). For the apex, pass `"@"` or the
#'   zone name.
#' @param content Record content. For `A`/`AAAA` an IP address; for
#'   `CNAME` a hostname; for `TXT` the string value.
#' @param ttl Time to live in seconds. `1` means "automatic"
#'   (Cloudflare's default).
#' @param proxied Logical. Whether the record is proxied through
#'   Cloudflare. Applies to A/AAAA/CNAME.
#' @param priority Integer. Required for `MX` records.
#' @param comment Optional human-readable comment.
#' @param ... Additional fields forwarded to the API for record
#'   types with extra requirements (`data` for `SRV`, etc.).
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created record.
#' @export
#' @family dns
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_create_dns_record",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_create_dns_record(
#'   "zone-1",
#'   type    = "A",
#'   name    = "www",
#'   content = "192.0.2.1",
#'   proxied = TRUE
#' )
#' \dontshow{vcr::eject_cassette()}
cf_create_dns_record <- function(
  zone_id,
  type,
  name,
  content,
  ttl = 1,
  proxied = NULL,
  priority = NULL,
  comment = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  body <- drop_nulls(list(
    type = type,
    name = name,
    content = content,
    ttl = ttl,
    proxied = proxied,
    priority = priority,
    comment = comment,
    ...
  ))
  cf_request(
    c("zones", zone_id, "dns_records"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Update a DNS record
#'
#' Performs a `PATCH` on the record, only sending fields supplied
#' as non-`NULL`. Use a `PUT`-style replace via [cf_request()] if
#' you need to overwrite the entire record.
#'
#' @inheritParams cf_get_dns_record
#' @inheritParams cf_create_dns_record
#'
#' @return A named list describing the updated record.
#' @export
#' @family dns
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_update_dns_record",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_update_dns_record("zone-1", "rec-1", content = "192.0.2.2")
#' \dontshow{vcr::eject_cassette()}
cf_update_dns_record <- function(
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
) {
  cf_check_id(zone_id)
  cf_check_id(record_id)
  body <- drop_nulls(list(
    type = type,
    name = name,
    content = content,
    ttl = ttl,
    proxied = proxied,
    priority = priority,
    comment = comment,
    ...
  ))
  cf_request(
    c("zones", zone_id, "dns_records", record_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PATCH") |>
    httr2::req_body_json(body) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete a DNS record
#'
#' @inheritParams cf_get_dns_record
#'
#' @return A named list with the deleted record's `id`.
#' @export
#' @family dns
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_delete_dns_record", package = "cloudflarer")
#' }
#' cf_delete_dns_record("zone-1", "rec-1")
#' \dontshow{vcr::eject_cassette()}
cf_delete_dns_record <- function(
  zone_id,
  record_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(zone_id)
  cf_check_id(record_id)
  cf_request(
    c("zones", zone_id, "dns_records", record_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
}
