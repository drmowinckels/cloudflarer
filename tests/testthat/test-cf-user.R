describe("cf_user()", {
  it("calls the user endpoint", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"user-1","email":"x@example.com"}}'
    )
    local_mock_auth()
    res <- cf_user()
    expect_match(cap$req$url, "/user$")
    expect_equal(res$id, "user-1")
  })
})
