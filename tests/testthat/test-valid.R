test_that("valid", {
    x <- valid()
    expect_type(x, "logical")
})
