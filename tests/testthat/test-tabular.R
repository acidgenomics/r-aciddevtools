context("tabular")

test_that("tabular", {
    df <- data.frame(
        "aaa" = seq(from = 1L, to = 4L),
        "bbb" = seq(from = 2L, to = 5L),
        "ccc" = seq(from = 3L, to = 6L),
        row.names = c("AAA", "BBB", "CCC", "DDD")
    )
    out <- capture.output({
        tabular(df)
    })
    expect_identical(
        object = out,
        expected = c(
            "\\tabular{rrr}{",
            "  1 \\tab 2 \\tab 3\\cr",
            "  2 \\tab 3 \\tab 4\\cr",
            "  3 \\tab 4 \\tab 5\\cr",
            "  4 \\tab 5 \\tab 6",
            "}"
        )
    )
})
