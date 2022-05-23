test_that("saveRdExamples", {
    rd <- c("do.call", "droplevels")
    testdir <- file.path(tempdir(), "testdata")
    unlink(testdir, recursive = TRUE)
    out <- saveRdExamples(
        rd = rd,
        package = "base",
        dir = testdir
    )
    expect_identical(
        object = basename(out),
        expected = paste0(rd, ".R")
    )
    expect_identical(
        object = sort(list.files(
            path = testdir,
            pattern = "*.R",
            full.names = FALSE,
            recursive = FALSE
        )),
        expected = paste0(rd, ".R")
    )
    unlink(testdir, recursive = TRUE)
})
