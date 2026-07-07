#' List D1 databases in an account
#'
#' Returns the D1 (serverless SQL) databases for the account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param name Optional name filter (substring match).
#' @param per_page,max_pages Pagination controls, see
#'   [cf_request_collect()].
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()].
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of D1 database records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family d1
#' @examples
#' \dontrun{
#' cf_list_d1_databases("acc-1")
#' }
cf_list_d1_databases <- function(
  account_id,
  name = NULL,
  per_page = 50,
  max_pages = Inf,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  records <- cf_request_collect(
    paste0("accounts/", account_id, "/d1/database"),
    query = list(name = name),
    per_page = per_page,
    max_pages = max_pages,
    token = token,
    email = email,
    api_key = api_key
  )
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single D1 database
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param database_id Character. D1 database `uuid`.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the database.
#' @export
#' @family d1
#' @examples
#' \dontrun{
#' cf_get_d1_database("acc-1", "db-1")
#' }
cf_get_d1_database <- function(
  account_id,
  database_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("accounts/", account_id, "/d1/database/", database_id),
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Create a D1 database
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param name Database name. Must be unique within the account.
#' @param primary_location_hint Optional Cloudflare region hint
#'   (`"WNAM"`, `"ENAM"`, `"WEUR"`, `"EEUR"`, `"APAC"`, `"OC"`).
#' @param ... Additional fields forwarded to the API.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the created database.
#' @export
#' @family d1
#' @examples
#' \dontrun{
#' cf_create_d1_database("acc-1", name = "users")
#' }
cf_create_d1_database <- function(
  account_id,
  name,
  primary_location_hint = NULL,
  ...,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  body <- drop_nulls(list(
    name = name,
    primary_location_hint = primary_location_hint,
    ...
  ))
  cf_request(
    paste0("accounts/", account_id, "/d1/database"),
    method = "POST",
    body = body,
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Delete a D1 database
#'
#' @inheritParams cf_get_d1_database
#'
#' @return A named list with the API response.
#' @export
#' @family d1
#' @examples
#' \dontrun{
#' cf_delete_d1_database("acc-1", "db-1")
#' }
cf_delete_d1_database <- function(
  account_id,
  database_id,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_request(
    paste0("accounts/", account_id, "/d1/database/", database_id),
    method = "DELETE",
    token = token,
    email = email,
    api_key = api_key
  )
}

#' Run a SQL query against a D1 database
#'
#' Executes one or more SQL statements against the database. Use
#' `params` for parameterised queries to avoid string-interpolation
#' issues.
#'
#' @inheritParams cf_get_d1_database
#' @param sql Character. SQL statement(s) to execute.
#' @param params Optional character vector of positional parameters
#'   bound to the `?` placeholders in `sql`.
#' @param as_df Logical. When `TRUE` (the default), returns the first
#'   result set as a data.frame via [cf_records_to_df()]. Set to
#'   `FALSE` to get the full raw response (useful for multi-statement
#'   queries or when you need the metadata).
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of result rows when `as_df = TRUE`, otherwise
#'   the raw response (a list of result blocks, each with `success`,
#'   `meta`, and `results`).
#' @export
#' @family d1
#' @examples
#' \dontrun{
#' cf_d1_query("acc-1", "db-1", "SELECT * FROM users WHERE id = ?", params = "42")
#' }
cf_d1_query <- function(
  account_id,
  database_id,
  sql,
  params = NULL,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  body <- drop_nulls(list(sql = sql, params = params))
  res <- cf_request(
    paste0("accounts/", account_id, "/d1/database/", database_id, "/query"),
    method = "POST",
    body = body,
    token = token,
    email = email,
    api_key = api_key
  )
  if (!as_df) {
    return(res)
  }
  rows <- res[[1]]$results %||% list()
  cf_records_to_df(rows)
}
