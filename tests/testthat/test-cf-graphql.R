describe("cf_graphql()", {
  it("returns the full body on a successful query", {
    local_mock_auth()
    vcr::use_cassette("graphql_viewer_ok", {
      res <- cf_graphql("{ viewer { accounts { id name } } }")
    })
    expect_named(res, "data")
    expect_length(res$data$viewer$accounts, 2)
    expect_equal(res$data$viewer$accounts[[1]]$id, "acc-1")
  })

  it("raises a classed error when errors[] is non-empty", {
    local_mock_auth()
    vcr::use_cassette("graphql_error", {
      expect_error(
        cf_graphql("{ broken }"),
        class = "cloudflarer_error"
      )
    })
  })

  it("aborts when variables are unnamed", {
    local_mock_auth()
    expect_error(
      cf_graphql("query Q($x: Int!) { foo }", 42),
      class = "cloudflarer_error"
    )
  })
})

describe("build_graphql_request()", {
  it("forces empty variables to a named list so JSON renders as {}", {
    local_mock_auth()
    req <- build_graphql_request("{ foo }", variables = list())
    expect_equal(
      req$body$data$variables,
      structure(list(), names = character(0))
    )
  })

  it("includes operationName when supplied", {
    local_mock_auth()
    req <- build_graphql_request(
      "query A { a } query B { b }",
      variables = list(),
      operation_name = "B"
    )
    expect_equal(req$body$data$operationName, "B")
  })

  it("omits operationName when NULL", {
    local_mock_auth()
    req <- build_graphql_request(
      "{ foo }",
      variables = list(),
      operation_name = NULL
    )
    expect_false("operationName" %in% names(req$body$data))
  })
})

describe("cf_graphql_envelope()", {
  it("returns the body on success", {
    fake_resp <- response(
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw('{"data":{"x":1}}')
    )
    expect_equal(cf_graphql_envelope(fake_resp), list(data = list(x = 1L)))
  })

  it("raises cloudflarer_error when errors[] is non-empty", {
    fake_resp <- response(
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw(
        '{"data":null,"errors":[{"message":"boom","path":["foo"]}]}'
      )
    )
    expect_error(cf_graphql_envelope(fake_resp), class = "cloudflarer_error")
  })

  it("raises cloudflarer_error on non-JSON bodies", {
    fake_resp <- response(
      status_code = 500,
      headers = list(`content-type` = "text/html"),
      body = charToRaw("<html>bad</html>")
    )
    expect_error(cf_graphql_envelope(fake_resp), class = "cloudflarer_error")
  })
})

describe("validate_graphql_variables()", {
  it("returns invisibly when empty", {
    expect_equal(validate_graphql_variables(list()), list())
  })

  it("aborts when any variable is unnamed", {
    expect_error(
      validate_graphql_variables(list(1, named = 2)),
      class = "cloudflarer_error"
    )
    expect_error(
      validate_graphql_variables(list(a = 1, 2)),
      class = "cloudflarer_error"
    )
  })

  it("accepts a fully-named list", {
    expect_equal(
      validate_graphql_variables(list(a = 1, b = "x")),
      list(a = 1, b = "x")
    )
  })
})

describe("format_graphql_error()", {
  it("escapes braces and includes path when present", {
    out <- format_graphql_error(list(
      message = "broke {x}",
      path = list("foo", "bar")
    ))
    expect_match(out, "broke")
    expect_match(out, "path: foo.bar")
    expect_match(out, "\\{\\{x\\}\\}")
  })

  it("falls back to a placeholder when message is missing", {
    out <- format_graphql_error(list(path = list("foo")))
    expect_match(out, "Unknown error")
  })
})
