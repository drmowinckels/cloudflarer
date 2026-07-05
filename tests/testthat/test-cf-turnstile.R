describe("cf_list_turnstile_widgets()", {
  it("returns a data.frame of widgets from a cassette", {
    local_mock_auth()
    vcr::use_cassette("turnstile_widgets_list", {
      df <- cf_list_turnstile_widgets("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("comment-form", "signup-form"))
    expect_equal(df$mode, c("managed", "invisible"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("turnstile_widgets_list", {
      res <- cf_list_turnstile_widgets("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$sitekey, "0x4AAAAAAAAA1")
  })
})

describe("cf_get_turnstile_widget()", {
  it("returns a single widget", {
    local_mock_auth()
    vcr::use_cassette("turnstile_widget_get", {
      w <- cf_get_turnstile_widget("acc-1", "0x4AAAAAAAAA1")
    })
    expect_equal(w$name, "comment-form")
    expect_equal(w$mode, "managed")
  })
})

describe("cf_create_turnstile_widget()", {
  it("POSTs the widget and returns sitekey + secret", {
    local_mock_auth()
    vcr::use_cassette("turnstile_widget_create", {
      w <- cf_create_turnstile_widget(
        "acc-1",
        name = "comment-form",
        domains = "example.com"
      )
    })
    expect_equal(w$sitekey, "0x4AAAAAAAAAnew")
    expect_equal(w$secret, "0x4AAAAAAAAAsec")
  })

  it("forwards the body to cf_request", {
    captured <- NULL
    local_mocked_bindings(
      cf_request = function(endpoint, method, body, ...) {
        captured <<- list(endpoint = endpoint, method = method, body = body)
        list(sitekey = "x")
      }
    )
    cf_create_turnstile_widget(
      "acc-1",
      name = "form",
      domains = c("a.com", "b.com"),
      mode = "invisible",
      bot_fight_mode = TRUE
    )
    expect_equal(
      captured$endpoint,
      c("accounts", "acc-1", "challenges", "widgets")
    )
    expect_equal(captured$method, "POST")
    expect_equal(captured$body$name, "form")
    expect_equal(captured$body$domains, list("a.com", "b.com"))
    expect_equal(captured$body$mode, "invisible")
    expect_true(captured$body$bot_fight_mode)
  })

  it("rejects unknown modes", {
    expect_error(
      cf_create_turnstile_widget("acc-1", "name", "x.com", mode = "weird"),
      "should be one of"
    )
  })
})

describe("cf_delete_turnstile_widget()", {
  it("DELETEs the widget", {
    local_mock_auth()
    vcr::use_cassette("turnstile_widget_delete", {
      res <- cf_delete_turnstile_widget("acc-1", "0x4AAAAAAAAA1")
    })
    expect_equal(res$sitekey, "0x4AAAAAAAAA1")
  })
})
