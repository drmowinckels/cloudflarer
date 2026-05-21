#' Convert a list of Cloudflare records to a data.frame
#'
#' Helper that takes a list of named records (typically the `result`
#' array from a Cloudflare REST endpoint) and returns a data.frame
#' with one row per record. Scalar fields become typed columns;
#' vector- or object-valued fields become list-columns.
#'
#' @param records A list of named lists with broadly consistent
#'   field names. Missing fields become `NA`.
#'
#' @return A data.frame with one row per record and columns named
#'   by the union of field names. Empty input returns an empty
#'   data.frame.
#'
#' @export
#' @family helpers
#' @examples
#' records <- list(
#'   list(id = "a", name = "alpha", tags = c("x", "y")),
#'   list(id = "b", name = "beta",  tags = character(0))
#' )
#' cf_records_to_df(records)
cf_records_to_df <- function(records) {
  if (!length(records)) {
    return(as_cf_tibble(data.frame()))
  }
  all_names <- unique(unlist(lapply(records, names), use.names = FALSE))
  cols <- lapply(all_names, function(field) {
    vals <- lapply(records, function(r) r[[field]])
    col <- simplify_column(vals)
    if (is.list(col)) I(col) else col
  })
  names(cols) <- all_names
  out <- data.frame(
    cols,
    row.names = seq_along(records),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  as_cf_tibble(out)
}

#' Add tibble classes to a data.frame
#'
#' Sets `class` to `c("tbl_df", "tbl", "data.frame")` so callers
#' with the tibble package loaded get tibble-style printing for
#' free. Users without tibble see (and operate on) the object as
#' a plain data.frame because tibble's S3 methods are only
#' dispatched when the package is attached.
#'
#' @keywords internal
#' @noRd
as_cf_tibble <- function(x) {
  if (!inherits(x, "data.frame")) {
    return(x)
  }
  class(x) <- c("tbl_df", "tbl", "data.frame")
  x
}

simplify_column <- function(vals) {
  non_null <- vals[!vapply(vals, is.null, logical(1))]
  if (!length(non_null)) {
    return(rep(NA, length(vals)))
  }
  scalar <- vapply(
    non_null,
    function(v) length(v) == 1L && !is.list(v),
    logical(1)
  )
  if (!all(scalar)) {
    return(vals)
  }
  example <- non_null[[1]]
  if (is.logical(example)) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA else as.logical(v),
      logical(1)
    ))
  }
  if (is.integer(example)) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA_integer_ else as.integer(v),
      integer(1)
    ))
  }
  if (is.numeric(example)) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA_real_ else as.numeric(v),
      numeric(1)
    ))
  }
  vapply(
    vals,
    function(v) if (is.null(v)) NA_character_ else as.character(v),
    character(1)
  )
}

#' Format a date or datetime as ISO-8601 UTC
#' @keywords internal
#' @noRd
format_iso8601 <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  if (inherits(x, "POSIXt")) {
    return(strftime(x, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"))
  }
  if (inherits(x, "Date")) {
    return(strftime(
      as.POSIXct(x, tz = "UTC"),
      "%Y-%m-%dT%H:%M:%SZ",
      tz = "UTC"
    ))
  }
  as.character(x)
}

#' Format a Date or POSIXct as Cloudflare GraphQL `Date` (YYYY-MM-DD)
#' @keywords internal
#' @noRd
format_gql_date <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  if (inherits(x, c("Date", "POSIXt"))) {
    return(format(as.Date(x), "%Y-%m-%d"))
  }
  as.character(x)
}

# nocov start
mock_if_no_auth <- function() {
  if (!cf_has_auth()) {
    Sys.setenv(CLOUDFLARE_API_TOKEN = "test-token-for-vcr-cassettes")
  }
}
# nocov end
