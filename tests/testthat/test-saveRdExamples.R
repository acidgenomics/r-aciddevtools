context("saveRdExamples")

test_that("saveRdExamples", {
    rd <- c("do.call", "droplevels")
    dir <- "testdata"
    unlink(dir, recursive = TRUE)
    out <- saveRdExamples(
        rd = rd,
        package = "base",
        dir = dir
    )
    expect_identical(
        object = basename(out),
        expected = paste0(rd, ".R")
    )
    expect_identical(
        object = sort(list.files(
            path = dir,
            pattern = "*.R",
            full.names = FALSE,
            recursive = FALSE
        )),
        expected = paste0(rd, ".R")
    )
    unlink(dir, recursive = TRUE)
})
