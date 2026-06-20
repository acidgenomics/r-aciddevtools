test_that("valid", {
    skip_if_not(goalie::hasInternet())
    x <- valid()
    expect_type(x, "logical")
})
