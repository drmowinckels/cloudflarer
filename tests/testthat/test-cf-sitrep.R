describe("cf_sitrep()", {
  it("reports a missing credential", {
    local_no_auth()
    expect_snapshot(res <- cf_sitrep())
    expect_true(is.na(res$auth_mode))
    expect_false(res$verified)
    expect_null(res$verification)
  })

  it("reports token auth and a verified credential", {
    local_mocked_bindings(
      cf_verify = function(...) list(id = "tok", status = "active")
    )
    local_mock_auth()
    expect_snapshot(res <- cf_sitrep())
    expect_equal(res$auth_mode, "token")
    expect_true(res$verified)
  })

  it("reports key auth and a verified credential", {
    local_mocked_bindings(
      cf_verify = function(...) list(email = "me@example.com")
    )
    local_mock_key_auth()
    expect_snapshot(res <- cf_sitrep())
    expect_equal(res$auth_mode, "key")
    expect_true(res$verified)
  })

  it("reports verification failure without aborting", {
    local_mocked_bindings(
      cf_verify = function(...) stop("nope")
    )
    local_mock_auth()
    expect_snapshot(res <- cf_sitrep())
    expect_false(res$verified)
  })
})
