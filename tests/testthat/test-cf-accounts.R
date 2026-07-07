describe("cf_list_accounts()", {
  it("calls the accounts endpoint with the name and page-size query", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_accounts(name = "acme", per_page = 25, max_pages = 2)
    expect_match(cap$req$url, "/accounts")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$name, "acme")
    expect_equal(query$per_page, "25")
  })
})

describe("cf_list_accounts() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_collect = function(req, ...) list(list(id = "a"), list(id = "b"))
    )
    local_mock_auth()
    res <- cf_list_accounts(as_df = FALSE)
    expect_type(res, "list")
    expect_equal(res[[2]]$id, "b")
  })
})

describe("cf_get_account()", {
  it("calls the accounts/{id} endpoint", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"acc-1"}}'
    )
    local_mock_auth()
    res <- cf_get_account("acc-1")
    expect_match(cap$req$url, "accounts/acc-1$")
    expect_equal(res$id, "acc-1")
  })
})
