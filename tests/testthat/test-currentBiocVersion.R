test_that("currentBiocVersion", {
    x <- currentBiocVersion()
    expect_s3_class(x, "package_version")
})
