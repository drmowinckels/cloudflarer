describe("cf_list_tunnels()", {
  it("returns a data.frame of tunnels from a cassette", {
    local_mock_auth()
    vcr::use_cassette("tunnels_list", {
      df <- cf_list_tunnels("acc-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$name, c("homelab", "dev-machine"))
    expect_equal(df$status, c("healthy", "inactive"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("tunnels_list", {
      res <- cf_list_tunnels("acc-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "tun-1")
  })
})

describe("cf_get_tunnel()", {
  it("returns a single tunnel", {
    local_mock_auth()
    vcr::use_cassette("tunnel_get", {
      t <- cf_get_tunnel("acc-1", "tun-1")
    })
    expect_equal(t$id, "tun-1")
    expect_equal(t$name, "homelab")
    expect_length(t$connections, 1)
  })
})

describe("cf_list_tunnel_connections()", {
  it("returns a data.frame of connections from a cassette", {
    local_mock_auth()
    vcr::use_cassette("tunnel_connections", {
      df <- cf_list_tunnel_connections("acc-1", "tun-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$origin_ip, c("192.0.2.1", "192.0.2.2"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("tunnel_connections", {
      res <- cf_list_tunnel_connections("acc-1", "tun-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "conn-1")
  })
})
