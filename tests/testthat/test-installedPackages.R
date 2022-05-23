test_that("installedPackages", {
    x <- installedPackages()
    expect_s3_class(x, "data.frame")
})
