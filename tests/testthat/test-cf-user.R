describe("cf_user()", {
  it("calls the user endpoint", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, ...) {
        captured <<- endpoint
        list(id = "user-1", email = "x@example.com")
      }
    )
    res <- cf_user()
    expect_equal(captured, "user")
    expect_equal(res$id, "user-1")
  })
})
