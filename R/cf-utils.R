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
  if (
    !is.list(records) ||
      !all(vapply(records, is.list, logical(1)))
  ) {
    cli::cli_abort(c(
      "{.arg records} must be a list of named lists.",
      i = "Got an object of class {.cls {class(records)}}."
    ))
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
  classed <- vapply(non_null, function(v) !is.null(oldClass(v)), logical(1))
  if (any(classed)) {
    return(vals)
  }
  types <- vapply(non_null, typeof, character(1))
  if (all(types == "logical")) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA else as.logical(v),
      logical(1)
    ))
  }
  if (all(types == "integer")) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA_integer_ else as.integer(v),
      integer(1)
    ))
  }
  if (all(types %in% c("integer", "double"))) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA_real_ else as.numeric(v),
      numeric(1)
    ))
  }
  if (all(types == "character")) {
    return(vapply(
      vals,
      function(v) if (is.null(v)) NA_character_ else as.character(v),
      character(1)
    ))
  }
  vals
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

#' Validate a length-one logical flag
#'
#' Guards a boolean argument, aborting with a consistent message when
#' the input is not a length-one non-`NA` logical. Used by wrappers
#' whose boolean flag is a filter that should only be serialized when
#' `TRUE` (so [cf_query_bool()], which always serializes, does not
#' fit) but which still deserve the same validation message.
#'
#' @param x A length-one logical.
#' @return `x`, invisibly.
#' @keywords internal
#' @noRd
cf_check_flag <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be {.code TRUE} or {.code FALSE}.",
      call = call
    )
  }
  invisible(x)
}

#' Serialize a logical for use in a Cloudflare query string
#'
#' httr2 serializes logicals as `TRUE`/`FALSE` but Cloudflare's
#' REST API expects lowercase `true`/`false`. This helper enforces
#' the convention so every wrapper passing a boolean query parameter
#' uses the same encoding, and rejects any input that is not a
#' length-one non-`NA` logical.
#'
#' @param x A length-one logical.
#' @return A lowercase character scalar (`"true"` or `"false"`).
#' @keywords internal
#' @noRd
cf_query_bool <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  cf_check_flag(x, arg = arg, call = call)
  if (x) "true" else "false"
}

#' Validate a URL-path-segment argument
#'
#' Used by endpoint wrappers to fail fast with a useful message when
#' callers pass `NULL`, `NA`, an empty string, or a non-character
#' value as any argument that ends up interpolated into a request
#' path. Despite the name, the helper guards more than just IDs:
#' setting names, project names, bucket names, sitekeys, etc. all
#' use it because a missing value here silently re-routes the call
#' to the parent collection endpoint.
#'
#' @keywords internal
#' @noRd
cf_check_id <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (!is_nonempty_string(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a non-empty character string.",
      call = call
    )
  }
  invisible(x)
}

#' Validate a URL-path-segment argument that must not itself contain
#' path separators
#'
#' [cf_req_path()] splits every element of the endpoint vector on
#' `/` before appending it as one or more URL path segments, so a
#' path-segment argument that is free-form user text (as opposed to
#' an opaque Cloudflare-issued ID) can smuggle extra `/` or `..`
#' segments into the request path -- redirecting the call to a
#' different, unintended endpoint under the same credentials. Use
#' this instead of [cf_check_id()] for any argument that (a) is
#' spliced into a request path and (b) is chosen by the caller
#' rather than returned by a prior Cloudflare API call.
#'
#' @inheritParams cf_check_id
#' @keywords internal
#' @noRd
cf_check_path_id <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  cf_check_id(x, arg = arg, call = call)
  if (grepl("/", x, fixed = TRUE) || x %in% c(".", "..")) {
    cli::cli_abort(
      "{.arg {arg}} must not contain {.val /} or be {.val .} or {.val ..}.",
      call = call
    )
  }
  invisible(x)
}

#' Validate a `dimension` argument used as a GraphQL field name
#'
#' Used by "top N by dimension" wrappers that splice the
#' caller-supplied `dimension` directly into a GraphQL query string
#' (as the field requested inside a `dimensions { ... }` selection
#' set) and also name their first output column after it, next to a
#' fixed metric column (`count`, `events`, ...).
#'
#' Two independent failure modes are guarded here:
#'
#' * `dimension` must look like a single GraphQL field name
#'   (`^[A-Za-z_][A-Za-z0-9_]*$`). Without this check, an
#'   unvalidated `dimension` is interpolated verbatim into the
#'   query text, so any caller-controlled value -- for example one
#'   forwarded from a Shiny input or URL parameter by code built on
#'   top of this package -- could break out of the intended
#'   selection set and request additional fields.
#' * `dimension` must not equal `reserved`, the fixed metric column
#'   name, since `data.frame` silently allows duplicate column
#'   names and `$` access on the result becomes ambiguous.
#'
#' @keywords internal
#' @noRd
cf_check_dimension_name <- function(
  dimension,
  reserved,
  arg = rlang::caller_arg(dimension),
  call = rlang::caller_env()
) {
  if (
    !is_nonempty_string(dimension) ||
      !grepl("^[A-Za-z_][A-Za-z0-9_]*$", dimension)
  ) {
    cli::cli_abort(
      paste(
        "{.arg {arg}} must be a single GraphQL field name (letters,",
        "digits, underscores; not starting with a digit)."
      ),
      call = call
    )
  }
  if (identical(dimension, reserved)) {
    cli::cli_abort(
      "{.arg {arg}} cannot be {.val {reserved}}: that name is already used for the metric column.",
      call = call
    )
  }
  invisible(dimension)
}
