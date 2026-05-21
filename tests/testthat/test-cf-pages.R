describe("cf_list_pages_projects()", {
  it("returns a data.frame of projects from a cassette", {
    local_mock_auth()
    vcr::use_cassette("pages_projects_list", {
      df <- cf_list_pages_projects("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("my-site", "blog"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("pages_projects_list", {
      res <- cf_list_pages_projects("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$name, "my-site")
  })
})

describe("cf_get_pages_project()", {
  it("returns a single project with build_config", {
    local_mock_auth()
    vcr::use_cassette("pages_project_get", {
      p <- cf_get_pages_project("acc-1", "my-site")
    })
    expect_equal(p$name, "my-site")
    expect_equal(p$build_config$build_command, "npm run build")
  })
})

describe("cf_list_pages_deployments()", {
  it("returns a data.frame of deployments from a cassette", {
    local_mock_auth()
    vcr::use_cassette("pages_deployments_list", {
      df <- cf_list_pages_deployments("acc-1", "my-site")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_true("environment" %in% names(df))
    expect_equal(df$environment, c("production", "preview"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("pages_deployments_list", {
      res <- cf_list_pages_deployments("acc-1", "my-site", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "dep-1")
  })
})
