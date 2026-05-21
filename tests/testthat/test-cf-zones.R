describe("cf_list_zones()", {
  it("forwards filters as query parameters", {
    captured <- NULL
    local_mocked_bindings(
      cf_request_collect = function(endpoint, query, ...) {
        captured <<- list(endpoint = endpoint, query = query)
        list()
      }
    )
    cf_list_zones(
      name = "example.com",
      status = "active",
      account_id = "acc-1"
    )
    expect_equal(captured$endpoint, "zones")
    expect_equal(captured$query$name, "example.com")
    expect_equal(captured$query$status, "active")
    expect_equal(captured$query$`account.id`, "acc-1")
  })
})

describe("cf_list_zones() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_request_collect = function(...) list(list(id = "z-1"))
    )
    res <- cf_list_zones(as_df = FALSE)
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "z-1")
  })
})

describe("cf_get_zone()", {
  it("calls the zones/{id} endpoint", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, ...) {
        captured <<- endpoint
        list(id = "zone-1")
      }
    )
    res <- cf_get_zone("zone-1")
    expect_equal(captured, "zones/zone-1")
    expect_equal(res$id, "zone-1")
  })
})
