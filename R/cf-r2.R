#' List R2 buckets in an account
#'
#' Returns the R2 object-storage buckets in the supplied account.
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param as_df Logical. When `TRUE` (the default), returns a
#'   data.frame via [cf_records_to_df()]. Set to `FALSE` for the
#'   raw nested list.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A data.frame of bucket records (or list when
#'   `as_df = FALSE`).
#' @export
#' @family r2
#' @examples
#' \dontrun{
#' cf_list_r2_buckets("abc123")
#' }
cf_list_r2_buckets <- function(
  account_id,
  as_df = TRUE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  res <- cf_request(
    c("accounts", account_id, "r2", "buckets"),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
  records <- res$buckets %||% list()
  if (as_df) cf_records_to_df(records) else records
}

#' Get a single R2 bucket
#'
#' @param account_id Character. Cloudflare account identifier.
#' @param bucket_name Character. R2 bucket name.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list describing the bucket.
#' @export
#' @family r2
#' @examples
#' \dontrun{
#' cf_get_r2_bucket("abc123", "my-bucket")
#' }
cf_get_r2_bucket <- function(
  account_id,
  bucket_name,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  cf_check_id(account_id)
  cf_check_id(bucket_name)
  cf_request(
    c("accounts", account_id, "r2", "buckets", bucket_name),
    token = token,
    email = email,
    api_key = api_key
  ) |>
    httr2::req_perform() |>
    cf_resp()
}
