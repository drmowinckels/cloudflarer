#' Purge zone cache
#'
#' Tells Cloudflare to drop cached content for a zone. Pass one
#' of the targeted-purge arguments to scope the purge, or set
#' `purge_everything = TRUE` to wipe the entire zone cache.
#'
#' Targeted purges are strictly preferred to wipes because cache
#' wipes can briefly increase origin load. Cloudflare also rate
#' limits the wipe endpoint per zone.
#'
#' @param zone_id Character. Cloudflare zone identifier.
#' @param files Optional character vector of URLs (or list of
#'   `list(url = ..., headers = ...)` for advanced purges with
#'   custom request headers).
#' @param hosts Optional character vector of hostnames whose cached
#'   content should be invalidated.
#' @param prefixes Optional character vector of URL prefixes
#'   (without scheme) to invalidate, e.g. `"example.com/blog"`.
#' @param tags Optional character vector of cache tags (Enterprise
#'   plan).
#' @param purge_everything Logical. When `TRUE`, ignores the
#'   targeted arguments and purges the entire zone cache.
#' @inheritParams cf_token
#' @inheritParams cf_email
#' @inheritParams cf_api_key
#'
#' @return A named list with the purge job `id`.
#' @export
#' @family cache
#' @examples
#' \dontrun{
#' cf_purge_cache("abc123", files = c(
#'   "https://example.com/index.html",
#'   "https://example.com/style.css"
#' ))
#'
#' cf_purge_cache("abc123", purge_everything = TRUE)
#' }
cf_purge_cache <- function(
  zone_id,
  files = NULL,
  hosts = NULL,
  prefixes = NULL,
  tags = NULL,
  purge_everything = FALSE,
  token = NULL,
  email = NULL,
  api_key = NULL
) {
  if (purge_everything) {
    body <- list(purge_everything = TRUE)
  } else {
    body <- drop_nulls(list(
      files = files,
      hosts = hosts,
      prefixes = prefixes,
      tags = tags
    ))
    if (!length(body)) {
      cli::cli_abort(c(
        "Nothing to purge.",
        i = paste(
          "Supply one of {.arg files}, {.arg hosts}, {.arg prefixes},",
          "{.arg tags}, or set {.arg purge_everything = TRUE}."
        )
      ))
    }
  }
  cf_request(
    paste0("zones/", zone_id, "/purge_cache"),
    method = "POST",
    body = body,
    token = token,
    email = email,
    api_key = api_key
  )
}
