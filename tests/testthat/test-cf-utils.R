describe("format_iso8601()", {
  it("returns NULL unchanged", {
    expect_null(format_iso8601(NULL))
  })

  it("formats POSIXct in UTC", {
    out <- format_iso8601(as.POSIXct("2026-05-01 12:34:56", tz = "UTC"))
    expect_equal(out, "2026-05-01T12:34:56Z")
  })

  it("formats Date at midnight UTC", {
    expect_equal(
      format_iso8601(as.Date("2026-05-01")),
      "2026-05-01T00:00:00Z"
    )
  })

  it("passes character through unchanged", {
    expect_equal(
      format_iso8601("2026-05-01T00:00:00Z"),
      "2026-05-01T00:00:00Z"
    )
  })
})

describe("format_gql_date()", {
  it("returns NULL unchanged", {
    expect_null(format_gql_date(NULL))
  })

  it("formats Date as YYYY-MM-DD", {
    expect_equal(format_gql_date(as.Date("2026-05-21")), "2026-05-21")
  })

  it("formats POSIXct as YYYY-MM-DD", {
    expect_equal(
      format_gql_date(as.POSIXct("2026-05-21 12:00:00", tz = "UTC")),
      "2026-05-21"
    )
  })

  it("passes character through unchanged", {
    expect_equal(format_gql_date("2026-05-21"), "2026-05-21")
  })
})

describe("as_cf_tibble()", {
  it("adds tbl_df classes so tibble users get tibble printing", {
    out <- as_cf_tibble(data.frame(a = 1:2, b = c("x", "y")))
    expect_s3_class(out, "tbl_df")
    expect_s3_class(out, "tbl")
    expect_s3_class(out, "data.frame")
  })

  it("is a no-op for non-data.frame input", {
    expect_equal(as_cf_tibble(1:3), 1:3)
    expect_equal(as_cf_tibble("foo"), "foo")
  })
})

describe("cf_records_to_df()", {
  it("returns an empty data.frame for empty input", {
    out <- cf_records_to_df(list())
    expect_s3_class(out, "data.frame")
    expect_equal(nrow(out), 0L)
  })

  it("returns scalar columns with detected types", {
    records <- list(
      list(id = "a", n = 1L, active = TRUE, score = 1.5),
      list(id = "b", n = 2L, active = FALSE, score = 2.5)
    )
    out <- cf_records_to_df(records)
    expect_type(out$id, "character")
    expect_type(out$n, "integer")
    expect_type(out$active, "logical")
    expect_type(out$score, "double")
    expect_equal(nrow(out), 2L)
  })

  it("fills missing fields with NA of the column type", {
    records <- list(
      list(id = "a", n = 1L),
      list(id = "b")
    )
    out <- cf_records_to_df(records)
    expect_equal(out$n, c(1L, NA_integer_))
  })

  it("keeps vector-valued fields as list-columns", {
    records <- list(
      list(id = "a", tags = c("x", "y")),
      list(id = "b", tags = character(0))
    )
    out <- cf_records_to_df(records)
    expect_type(out$tags, "list")
    expect_equal(out$tags[[1]], c("x", "y"))
  })

  it("keeps nested objects as list-columns", {
    records <- list(
      list(id = "a", account = list(id = "acc-1", name = "Acme")),
      list(id = "b", account = list(id = "acc-2", name = "Globex"))
    )
    out <- cf_records_to_df(records)
    expect_type(out$account, "list")
    expect_equal(out$account[[1]]$name, "Acme")
  })

  it("returns NA-only column when every value is NULL", {
    records <- list(list(id = "a", optional = NULL), list(id = "b"))
    out <- cf_records_to_df(records)
    expect_true(all(is.na(out$optional)))
  })

  it("promotes mixed integer+double values to double without truncating", {
    records <- list(list(n = 1L), list(n = 2.5))
    out <- cf_records_to_df(records)
    expect_type(out$n, "double")
    expect_equal(out$n, c(1, 2.5))
  })

  it("returns a double column when every value is already double", {
    records <- list(list(n = 1.1), list(n = 2.2))
    out <- cf_records_to_df(records)
    expect_type(out$n, "double")
    expect_equal(out$n, c(1.1, 2.2))
  })

  it("falls back to a list-column for incompatible mixed scalar types", {
    records <- list(list(v = 1L), list(v = "two"))
    out <- cf_records_to_df(records)
    expect_type(out$v, "list")
  })

  it("aborts on non-list input", {
    expect_error(cf_records_to_df(1:3), "must be a list")
  })

  it("aborts when an element is not a list", {
    expect_error(
      cf_records_to_df(list(list(a = 1), "not-a-list")),
      "must be a list"
    )
  })
})

describe("cf_query_bool()", {
  it("returns Cloudflare's lowercase form", {
    expect_equal(cf_query_bool(TRUE), "true")
    expect_equal(cf_query_bool(FALSE), "false")
  })

  it("aborts on non-logical input", {
    expect_error(cf_query_bool(1), "TRUE")
    expect_error(cf_query_bool("yes"), "TRUE")
  })

  it("aborts on NA or wrong length", {
    expect_error(cf_query_bool(NA), "TRUE")
    expect_error(cf_query_bool(c(TRUE, FALSE)), "TRUE")
    expect_error(cf_query_bool(logical(0)), "TRUE")
  })

  it("names the failing argument", {
    is_deleted <- "yes"
    expect_error(cf_query_bool(is_deleted), "is_deleted")
  })
})

describe("cf_check_id()", {
  it("passes for a non-empty character scalar", {
    expect_invisible(cf_check_id("abc"))
  })

  it("aborts for NULL", {
    expect_error(cf_check_id(NULL), "must be a non-empty character string")
  })

  it("aborts for empty string", {
    expect_error(cf_check_id(""), "must be a non-empty character string")
  })

  it("aborts for NA", {
    expect_error(
      cf_check_id(NA_character_),
      "must be a non-empty character string"
    )
  })

  it("aborts for length != 1", {
    expect_error(
      cf_check_id(c("a", "b")),
      "must be a non-empty character string"
    )
  })

  it("aborts for non-character", {
    expect_error(cf_check_id(42L), "must be a non-empty character string")
  })

  it("names the failing argument in the message", {
    zone_id <- NULL
    expect_error(cf_check_id(zone_id), "zone_id")
  })
})
