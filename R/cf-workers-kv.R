#' List Workers KV namespaces
#'
#' Returns the KV namespaces in the supplied account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param per_page,max_pages Pagination controls, see
#'   [cf_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of KV namespace records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_kv_namespaces", package = "cloudflarer")
#' }
#' cf_list_kv_namespaces("abc123")
#' \dontshow{vcr::eject_cassette()}
cf_list_kv_namespaces <- function(
  account_id,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  records <- cf_request(
    c("accounts", account_id, "storage", "kv", "namespaces"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    cf_collect(per_page = per_page, max_pages = max_pages)
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single Workers KV namespace
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param namespace_id Character. KV namespace identifier.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the namespace.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_kv_namespace", package = "cloudflarer")
#' }
#' cf_get_kv_namespace("abc123", "ns-1")
#' \dontshow{vcr::eject_cassette()}
cf_get_kv_namespace <- function(
  account_id,
  namespace_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_request(
    c("accounts", account_id, "storage", "kv", "namespaces", namespace_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Create a Workers KV namespace
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param title Character. Human-readable namespace name.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created namespace.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_create_kv_namespace",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_create_kv_namespace("abc123", "sessions")
#' \dontshow{vcr::eject_cassette()}
cf_create_kv_namespace <- function(
  account_id,
  title,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_id(title)
  cf_request(
    c("accounts", account_id, "storage", "kv", "namespaces"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(title = title)) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Rename a Workers KV namespace
#'
#' @inheritParams cf_get_kv_namespace
#' @param title Character. New namespace name.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the renamed namespace.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_rename_kv_namespace",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_rename_kv_namespace("abc123", "ns-1", "sessions-v2")
#' \dontshow{vcr::eject_cassette()}
cf_rename_kv_namespace <- function(
  account_id,
  namespace_id,
  title,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_check_id(title)
  cf_request(
    c("accounts", account_id, "storage", "kv", "namespaces", namespace_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PUT") |>
    httr2::req_body_json(list(title = title)) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete a Workers KV namespace
#'
#' @inheritParams cf_get_kv_namespace
#'
#' @return `NULL`, invisibly. Cloudflare returns an empty result on
#'   success.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_delete_kv_namespace", package = "cloudflarer")
#' }
#' cf_delete_kv_namespace("abc123", "ns-1")
#' \dontshow{vcr::eject_cassette()}
cf_delete_kv_namespace <- function(
  account_id,
  namespace_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_request(
    c("accounts", account_id, "storage", "kv", "namespaces", namespace_id),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
  invisible(NULL)
}

#' List the keys in a Workers KV namespace
#'
#' Walks the namespace's cursor-paginated `keys` endpoint and
#' concatenates every page into a single result. Unlike the
#' offset-paginated list endpoints wrapped by [cf_collect()],
#' Cloudflare paginates KV keys with an opaque cursor, so this
#' wrapper keeps its own loop instead.
#'
#' @inheritParams cf_get_kv_namespace
#' @param prefix Optional character. Restrict results to keys
#'   starting with this prefix.
#' @param limit Integer. Page size, between 10 and 1000.
#' @param max_pages Optional integer. Stop after collecting this
#'   many pages. `Inf` (the default) collects every key.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of key records (or list when
#'   `as_df = FALSE`), each with `name`, `expiration`, and
#'   `metadata` (when set).
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_list_kv_keys", package = "cloudflarer")
#' }
#' cf_list_kv_keys("abc123", "ns-1")
#' \dontshow{vcr::eject_cassette()}
cf_list_kv_keys <- function(
  account_id,
  namespace_id,
  prefix = NULL,
  limit = 1000,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  req <- cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "keys"
    ),
    token = token,
    email = email,
    api_key = api_key
  )
  results <- list()
  cursor <- NULL
  page <- 1L
  repeat {
    env <- req |>
      httr2::req_url_query(prefix = prefix, limit = limit, cursor = cursor) |>
      httr2::req_perform() |>
      cf_resp_envelope()
    if (!is.null(env[["result"]])) {
      results <- c(results, env[["result"]])
    }
    cursor <- env$result_info$cursor
    done <- isTRUE(env$result_info$list_complete) ||
      !length(cursor) ||
      !nzchar(cursor)
    if (done || page >= max_pages) {
      break
    }
    page <- page + 1L
  }
  if (as_df) cf_records_to_df(results) else results
}

#' Read a value from a Workers KV namespace
#'
#' Unlike most Cloudflare endpoints, this one returns the raw stored
#' value rather than a JSON envelope, so the result is not passed
#' through [cf_resp()].
#'
#' @inheritParams cf_get_kv_namespace
#' @param key_name Character. Key to read.
#' @param as Character. `"text"` (the default) returns the value as
#'   a string via [httr2::resp_body_string()]; `"raw"` returns the
#'   raw bytes via [httr2::resp_body_raw()], useful for binary
#'   values.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A character string, or a raw vector when `as = "raw"`.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_get_kv_value", package = "cloudflarer")
#' }
#' cf_get_kv_value("abc123", "ns-1", "greeting")
#' \dontshow{vcr::eject_cassette()}
cf_get_kv_value <- function(
  account_id,
  namespace_id,
  key_name,
  as = c("text", "raw"),
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_check_path_id(key_name)
  as <- match.arg(as)
  resp <- cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "values",
      key_name
    ),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform()
  if (httr2::resp_status(resp) >= 400L) {
    return(cf_resp_envelope(resp))
  }
  if (as == "raw") httr2::resp_body_raw(resp) else httr2::resp_body_string(resp)
}

#' Write a value to a Workers KV namespace
#'
#' @inheritParams cf_get_kv_value
#' @param value Character string or raw vector. The value to store.
#' @param expiration Optional integer. Absolute expiration time as a
#'   Unix timestamp (seconds).
#' @param expiration_ttl Optional integer. Expiration in seconds from
#'   now (minimum 60).
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return `TRUE`, invisibly, on success.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_put_kv_value",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_put_kv_value("abc123", "ns-1", "greeting", "hello world")
#' \dontshow{vcr::eject_cassette()}
cf_put_kv_value <- function(
  account_id,
  namespace_id,
  key_name,
  value,
  expiration = NULL,
  expiration_ttl = NULL,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_check_path_id(key_name)
  cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "values",
      key_name
    ),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PUT") |>
    httr2::req_url_query(
      expiration = expiration,
      expiration_ttl = expiration_ttl
    ) |>
    httr2::req_body_raw(value) |>
    httr2::req_perform() |>
    cf_resp()
  invisible(TRUE)
}

#' Delete a value from a Workers KV namespace
#'
#' @inheritParams cf_get_kv_value
#'
#' @return `NULL`, invisibly. Cloudflare returns an empty result on
#'   success.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette("cf_delete_kv_value", package = "cloudflarer")
#' }
#' cf_delete_kv_value("abc123", "ns-1", "greeting")
#' \dontshow{vcr::eject_cassette()}
cf_delete_kv_value <- function(
  account_id,
  namespace_id,
  key_name,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  cf_check_path_id(key_name)
  cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "values",
      key_name
    ),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_perform() |>
    cf_resp()
  invisible(NULL)
}

#' Write multiple key-value pairs to a Workers KV namespace
#'
#' @inheritParams cf_get_kv_namespace
#' @param values A list of entries, each a named list with a `key`
#'   and `value` element, and optionally `expiration`,
#'   `expiration_ttl`, `metadata`, or `base64` (see the
#'   [Cloudflare API docs](https://developers.cloudflare.com/api/)
#'   for the bulk write endpoint). Up to 10,000 entries per call.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with `successful_key_count` and
#'   `unsuccessful_keys`.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_put_kv_values",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_put_kv_values(
#'   "abc123",
#'   "ns-1",
#'   list(
#'     list(key = "greeting", value = "hello"),
#'     list(key = "farewell", value = "bye", expiration_ttl = 3600)
#'   )
#' )
#' \dontshow{vcr::eject_cassette()}
cf_put_kv_values <- function(
  account_id,
  namespace_id,
  values,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  if (!is.list(values) || !length(values)) {
    cli::cli_abort(
      "{.arg values} must be a non-empty list of key-value entries."
    )
  }
  cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "bulk"
    ),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("PUT") |>
    httr2::req_body_json(values) |>
    httr2::req_perform() |>
    cf_resp()
}

#' Delete multiple keys from a Workers KV namespace
#'
#' @inheritParams cf_get_kv_namespace
#' @param keys Character vector of key names to delete. Up to
#'   10,000 keys per call.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with `successful_key_count` and
#'   `unsuccessful_keys`.
#' @export
#' @family workers
#' @examplesIf requireNamespace("vcr", quietly = TRUE)
#' \dontshow{
#' if (!nzchar(Sys.getenv("CLOUDFLARE_API_TOKEN"))) {
#'   Sys.setenv(CLOUDFLARE_API_TOKEN = "cloudflarer-example")
#' }
#' vcr::insert_example_cassette(
#'   "cf_delete_kv_values",
#'   package = "cloudflarer",
#'   match_requests_on = c("method", "uri")
#' )
#' }
#' cf_delete_kv_values("abc123", "ns-1", c("greeting", "farewell"))
#' \dontshow{vcr::eject_cassette()}
cf_delete_kv_values <- function(
  account_id,
  namespace_id,
  keys,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_path_id(account_id)
  cf_check_path_id(namespace_id)
  if (!is.character(keys) || !length(keys)) {
    cli::cli_abort(
      "{.arg keys} must be a non-empty character vector of key names."
    )
  }
  cf_request(
    c(
      "accounts",
      account_id,
      "storage",
      "kv",
      "namespaces",
      namespace_id,
      "bulk"
    ),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_method("DELETE") |>
    httr2::req_body_json(as.list(keys)) |>
    httr2::req_perform() |>
    cf_resp()
}
