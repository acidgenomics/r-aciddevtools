context("currentBiocVersion")

test_that("currentBiocVersion", {
    x <- currentBiocVersion()
    expect_is(x, "package_version")
})
