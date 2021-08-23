context("installedPackages")

test_that("installedPackages", {
    x <- installedPackages()
    expect_is(x, "data.frame")
})
