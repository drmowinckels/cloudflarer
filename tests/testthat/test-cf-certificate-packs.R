describe("cf_list_certificate_packs()", {
  it("returns a data.frame of certificate packs", {
    local_mock_auth()
    vcr::use_cassette("certificate_packs_list", {
      df <- cf_list_certificate_packs("zone-1")
    })
    expect_s3_class(df, "data.frame")
    expect_equal(nrow(df), 2L)
    expect_equal(df$type, c("advanced", "universal"))
    expect_equal(df$status, c("active", "pending_validation"))
  })

  it("returns a list when as_df = FALSE", {
    local_mock_auth()
    vcr::use_cassette("certificate_packs_list", {
      res <- cf_list_certificate_packs("zone-1", as_df = FALSE)
    })
    expect_type(res, "list")
    expect_equal(res[[1]]$id, "pack-1")
  })
})

describe("cf_get_certificate_pack()", {
  it("returns a single certificate pack", {
    local_mock_auth()
    vcr::use_cassette("certificate_pack_get", {
      pack <- cf_get_certificate_pack("zone-1", "pack-1")
    })
    expect_equal(pack$id, "pack-1")
    expect_equal(pack$type, "advanced")
    expect_equal(unlist(pack$hosts), c("example.com", "www.example.com"))
  })
})
