describe("cf_list_workers_scripts()", {
  it("returns a data.frame of scripts from a cassette", {
    local_mock_auth()
    vcr::use_cassette("workers_scripts_list", {
      df <- cf_list_workers_scripts("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true("id" %in% names(df))
    expect_equal(df$id, c("hello-world", "image-resizer"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("workers_scripts_list", {
      res <- cf_list_workers_scripts("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "hello-world")
  })
})

describe("cf_get_workers_script()", {
  it("targets the scripts/{name} endpoint", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, ...) {
        captured <<- endpoint
        list(id = "x")
      }
    )
    cf_get_workers_script("acc-1", "my-worker")
    expect_equal(
      captured,
      c("accounts", "acc-1", "workers", "scripts", "my-worker")
    )
  })
})

describe("cf_workers_invocations()", {
  it("returns a tidy data.frame from a cassette", {
    local_mock_auth()
    vcr::use_cassette("workers_invocations", {
      df <- cf_workers_invocations(
        "acc-1",
        since = as.Date("2026-05-19"),
        until = as.Date("2026-05-21")
      )
    })
    expect_s3_class(df, "data.frame")
    expect_named(
      df,
      c(
        "date",
        "script",
        "requests",
        "errors",
        "subrequests",
        "cpu_p50_us",
        "cpu_p99_us"
      )
    )
    expect_equal(nrow(df), 2L)
    expect_equal(df$requests, c(10000L, 12500L))
    expect_equal(df$script, c("hello-world", "hello-world"))
  })

  it("includes scriptName filter in the query when supplied", {
    captured <- NULL
    local_mocked_bindings(
      cf_graphql = function(query, ...) {
        captured <<- query
        list(
          data = list(
            viewer = list(
              accounts = list(list(
                workersInvocationsAdaptive = list()
              ))
            )
          )
        )
      }
    )
    cf_workers_invocations(
      "acc-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20"),
      script_name = "my-script"
    )
    expect_match(captured, "scriptName")
  })

  it("returns an empty data.frame when there are no groups", {
    local_mocked_bindings(
      cf_graphql = function(...) {
        list(
          data = list(
            viewer = list(
              accounts = list(list(
                workersInvocationsAdaptive = list()
              ))
            )
          )
        )
      }
    )
    df <- cf_workers_invocations(
      "acc-1",
      since = as.Date("2026-05-19"),
      until = as.Date("2026-05-20")
    )
    expect_equal(nrow(df), 0L)
  })
})
