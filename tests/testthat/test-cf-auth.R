describe("cf_auth_mode()", {
  it("returns 'token' when only the token env var is set", {
    local_mock_auth()
    expect_equal(cf_auth_mode(), "token")
  })

  it("returns 'key' when only email + key env vars are set", {
    local_mock_key_auth()
    expect_equal(cf_auth_mode(), "key")
  })

  it("returns 'token' when both modes are configured", {
    local_envvar(
      CLOUDFLARE_API_TOKEN = mock_token,
      CLOUDFLARE_EMAIL = mock_email,
      CLOUDFLARE_API_KEY = mock_api_key
    )
    expect_equal(cf_auth_mode(), "token")
  })

  it("returns NA when no credentials are set", {
    local_no_auth()
    expect_true(is.na(cf_auth_mode()))
  })

  it("returns NA when only one of email or key is set", {
    local_envvar(
      CLOUDFLARE_API_TOKEN = "",
      CLOUDFLARE_EMAIL = mock_email,
      CLOUDFLARE_API_KEY = ""
    )
    expect_true(is.na(cf_auth_mode()))
  })
})

describe("cf_has_auth()", {
  it("is TRUE when token auth is configured", {
    local_mock_auth()
    expect_true(cf_has_auth())
  })

  it("is TRUE when key auth is configured", {
    local_mock_key_auth()
    expect_true(cf_has_auth())
  })

  it("is FALSE when no credentials are configured", {
    local_no_auth()
    expect_false(cf_has_auth())
  })
})

describe("cf_token()", {
  it("returns the value from the environment variable", {
    local_envvar(CLOUDFLARE_API_TOKEN = "abc")
    expect_equal(cf_token(), "abc")
  })

  it("accepts an explicit token argument", {
    local_envvar(CLOUDFLARE_API_TOKEN = "abc")
    expect_equal(cf_token("xyz"), "xyz")
  })

  it("aborts when no token is available", {
    local_envvar(CLOUDFLARE_API_TOKEN = "")
    expect_error(cf_token(), "No Cloudflare API token")
  })
})

describe("cf_email()", {
  it("returns the value from the environment variable", {
    local_envvar(CLOUDFLARE_EMAIL = "me@example.com")
    expect_equal(cf_email(), "me@example.com")
  })

  it("accepts an explicit email argument", {
    expect_equal(cf_email("other@example.com"), "other@example.com")
  })

  it("aborts when no email is available", {
    local_envvar(CLOUDFLARE_EMAIL = "")
    expect_error(cf_email(), "No Cloudflare account email")
  })
})

describe("cf_api_key()", {
  it("returns the value from the environment variable", {
    local_envvar(CLOUDFLARE_API_KEY = "topsecret")
    expect_equal(cf_api_key(), "topsecret")
  })

  it("accepts an explicit api_key argument", {
    expect_equal(cf_api_key("other"), "other")
  })

  it("aborts when no api_key is available", {
    local_envvar(CLOUDFLARE_API_KEY = "")
    expect_error(cf_api_key(), "Global API Key")
  })
})

describe("cf_token_verify()", {
  it("targets the verify endpoint", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"id":"tok","status":"active"}}'
    )
    local_mock_auth()
    res <- cf_token_verify()
    expect_match(cap$req$url, "user/tokens/verify$")
    expect_equal(res$status, "active")
  })
})

describe("cf_verify()", {
  it("uses /user/tokens/verify when token auth is active", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"status":"active"}}'
    )
    local_mock_auth()
    cf_verify()
    expect_match(cap$req$url, "user/tokens/verify$")
  })

  it("uses /user when key auth is active", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"email":"x@example.com"}}'
    )
    local_mock_key_auth()
    cf_verify()
    expect_match(cap$req$url, "/user$")
  })

  it("uses /user/tokens/verify when an explicit token is passed", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"status":"active"}}'
    )
    local_mock_key_auth()
    cf_verify(token = "abc")
    expect_match(cap$req$url, "user/tokens/verify$")
  })

  it("uses /user with explicit key auth even when an env token is set", {
    cap <- local_captured_request(
      body = '{"success":true,"result":{"email":"x@example.com"}}'
    )
    local_mock_auth()
    cf_verify(email = "e@example.com", api_key = "k")
    expect_match(cap$req$url, "/user$")
    headers <- httr2::req_dry_run(
      cap$req,
      quiet = TRUE,
      redact_headers = FALSE
    )$headers
    expect_equal(headers$`x-auth-email`, "e@example.com")
    expect_equal(headers$`x-auth-key`, "k")
  })

  it("aborts when no credentials are configured", {
    local_no_auth()
    expect_error(cf_verify(), "No Cloudflare credentials")
  })
})
