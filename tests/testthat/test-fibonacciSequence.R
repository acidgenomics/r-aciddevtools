context("fibonacciSequence")

test_that("fibonacciSequence", {
    expect_identical(
        object = fibonacciSequence(8L),
        expected = c(1L, 1L, 2L, 3L, 5L, 8L, 13L, 21L)
    )
})
