describe("cf_list_d1_databases()", {
  it("returns a data.frame of D1 databases", {
    local_mock_auth()
    vcr::use_cassette("d1_databases_list", {
      df <- cf_list_d1_databases("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("users", "events"))
    expect_equal(df$num_tables, c(4L, 12L))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("d1_databases_list", {
      res <- cf_list_d1_databases("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$uuid, "db-1")
  })
})

describe("cf_get_d1_database()", {
  it("returns a single D1 database", {
    local_mock_auth()
    vcr::use_cassette("d1_database_get", {
      db <- cf_get_d1_database("acc-1", "db-1")
    })
    expect_equal(db$uuid, "db-1")
    expect_equal(db$name, "users")
    expect_equal(db$running_in_region, "WEUR")
  })
})

describe("cf_create_d1_database()", {
  it("posts a D1 database and returns the created record", {
    local_mock_auth()
    vcr::use_cassette("d1_database_create", {
      db <- cf_create_d1_database("acc-1", name = "users")
    })
    expect_equal(db$uuid, "db-1")
    expect_equal(db$name, "users")
  })
})

describe("cf_delete_d1_database()", {
  it("deletes a D1 database", {
    local_mock_auth()
    vcr::use_cassette("d1_database_delete", {
      out <- cf_delete_d1_database("acc-1", "db-1")
    })
    expect_null(out)
  })
})

describe("cf_d1_query()", {
  it("returns a data.frame of result rows", {
    local_mock_auth()
    vcr::use_cassette("d1_database_query", {
      df <- cf_d1_query("acc-1", "db-1", "SELECT id, name FROM users")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("alice", "bob"))
  })

  it("returns the raw response when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("d1_database_query", {
      res <- cf_d1_query(
        "acc-1",
        "db-1",
        "SELECT id, name FROM users",
        as_df = FALSE
      )
    })
    expect_type(res, "list")
    expect_true(res[[1]]$success)
    expect_equal(res[[1]]$meta$rows_read, 2L)
  })
})
