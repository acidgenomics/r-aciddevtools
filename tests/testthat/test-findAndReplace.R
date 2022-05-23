test_that("Non-recursive", {
    testdir <- file.path(tempdir(), "testdata")
    unlink(testdir, recursive = TRUE)
    dir.create(file.path(testdir, "subdir"), recursive = TRUE)
    writeLines(
        text = "print(\"foo\")",
        con = file.path(testdir, "aaa.R")
    )
    writeLines(
        text = "print(\"foo\")",
        con = file.path(testdir, "subdir", "bbb.R")
    )
    out <- findAndReplace(
        pattern = "foo",
        replacement = "bar",
        dir = testdir,
        recursive = FALSE
    )
    expect_identical(
        object = basename(out),
        expected = "aaa.R"
    )
    expect_identical(
        object = readLines(out[[1L]]),
        expected = "print(\"bar\")"
    )
    unlink(testdir, recursive = TRUE)
})

test_that("Recursive", {
    testdir <- file.path(tempdir(), "testdata")
    unlink(testdir, recursive = TRUE)
    dir.create(file.path(testdir, "subdir"), recursive = TRUE)
    writeLines(
        text = "print(\"foo\")",
        con = file.path(testdir, "aaa.R")
    )
    writeLines(
        text = "print(\"foo\")",
        con = file.path(testdir, "subdir", "bbb.R")
    )
    out <- findAndReplace(
        pattern = "foo",
        replacement = "bar",
        dir = testdir,
        recursive = TRUE
    )
    expect_identical(
        object = basename(out),
        expected = c("aaa.R", "bbb.R")
    )
    for (file in out) {
        expect_identical(
            object = readLines(file),
            expected = "print(\"bar\")"
        )
    }
    unlink(testdir, recursive = TRUE)
})
