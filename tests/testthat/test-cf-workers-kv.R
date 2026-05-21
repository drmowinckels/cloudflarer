describe("cf_list_kv_namespaces()", {
  it("returns a data.frame of KV namespaces from a cassette", {
    local_mock_auth()
    vcr::use_cassette("kv_namespaces_list", {
      df <- cf_list_kv_namespaces("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$title, c("sessions", "feature-flags"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("kv_namespaces_list", {
      res <- cf_list_kv_namespaces("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "ns-1")
  })
})

describe("cf_get_kv_namespace()", {
  it("returns a single namespace", {
    local_mock_auth()
    vcr::use_cassette("kv_namespace_get", {
      ns <- cf_get_kv_namespace("acc-1", "ns-1")
    })
    expect_equal(ns$id, "ns-1")
    expect_equal(ns$title, "sessions")
  })
})
