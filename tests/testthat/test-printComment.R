test_that("printComment", {
    out <- capture.output({
        printComment(c("hello", "world"))
    })
    expect_identical(
        object = out,
        expected = "## [1] \"hello\" \"world\""
    )
})
