context("catVec")

test_that("catVec", {
    expect_output(
        object = catVec(c("aaa", "bbb")),
        regexp = "\"aaa\","
    )
})
