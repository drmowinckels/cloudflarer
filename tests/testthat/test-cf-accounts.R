describe("cf_list_accounts()", {
  it("calls the accounts endpoint with pagination", {
    args <- NULL
    local_mocked_bindings(
      cf_request_collect = function(endpoint, query, per_page, max_pages, ...) {
        args <<- list(
          endpoint = endpoint,
          query = query,
          per_page = per_page,
          max_pages = max_pages
        )
        list()
      }
    )
    cf_list_accounts(name = "acme", per_page = 25, max_pages = 2)
    expect_equal(args$endpoint, "accounts")
    expect_equal(args$query, list(name = "acme"))
    expect_equal(args$per_page, 25)
    expect_equal(args$max_pages, 2)
  })
})

describe("cf_list_accounts() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_request_collect = function(...) list(list(id = "a"), list(id = "b"))
    )
    res <- cf_list_accounts(as_df = FALSE)
    expect_type(res, "list")
    expect_equal(res[[2]]$id, "b")
  })
})

describe("cf_get_account()", {
  it("calls the accounts/{id} endpoint", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, ...) {
        captured <<- endpoint
        list(id = "acc-1")
      }
    )
    res <- cf_get_account("acc-1")
    expect_equal(captured, c("accounts", "acc-1"))
    expect_equal(res$id, "acc-1")
  })
})
