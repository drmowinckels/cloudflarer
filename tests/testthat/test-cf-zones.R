describe("cf_list_zones()", {
  it("forwards filters as query parameters", {
    cap <- local_captured_request()
    local_mock_auth()
    cf_list_zones(
      name = "example.com",
      status = "active",
      account_id = "acc-1"
    )
    expect_match(cap$req$url, "/zones")
    query <- httr2::url_parse(cap$req$url)$query
    expect_equal(query$name, "example.com")
    expect_equal(query$status, "active")
    expect_equal(query[["account.id"]], "acc-1")
  })
})

describe("cf_list_zones() as_df = FALSE", {
  it("returns the raw list when as_df = FALSE", {
    local_mocked_bindings(
      cf_collect = function(req, ...) list(list(id = "z-1"))
    )
    local_mock_auth()
    res <- cf_list_zones(as_df = FALSE)
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "z-1")
  })
})

describe("cf_get_zone()", {
  it("calls the zones/{id} endpoint", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"zone-1"}}'
    )
    local_mock_auth()
    res <- cf_get_zone("zone-1")
    expect_match(cap$req$url, "zones/zone-1$")
    expect_equal(res$id, "zone-1")
  })

  it("aborts when zone_id is empty rather than silently listing zones", {
    expect_error(cf_get_zone(""), "zone_id")
    expect_error(cf_get_zone(NULL), "zone_id")
    expect_error(cf_get_zone(NA_character_), "zone_id")
  })
})
