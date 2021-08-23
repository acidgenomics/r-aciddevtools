context("findAndReplace")

test_that("Non-recursive", {
    unlink("testdata", recursive = TRUE)
    dir.create(file.path("testdata", "subdir"), recursive = TRUE)
    writeLines(
        text = "print(\"foo\")",
        con = file.path("testdata", "aaa.R"),
    )
    writeLines(
        text = "print(\"foo\")",
        con = file.path("testdata", "subdir", "bbb.R"),
    )
    out <- findAndReplace(
        pattern = "foo",
        replacement = "bar",
        dir = "testdata",
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
    unlink("testdata", recursive = TRUE)
})

test_that("Recursive", {
    unlink("testdata", recursive = TRUE)
    dir.create(file.path("testdata", "subdir"), recursive = TRUE)
    writeLines(
        text = "print(\"foo\")",
        con = file.path("testdata", "aaa.R"),
    )
    writeLines(
        text = "print(\"foo\")",
        con = file.path("testdata", "subdir", "bbb.R"),
    )
    out <- findAndReplace(
        pattern = "foo",
        replacement = "bar",
        dir = "testdata",
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
    unlink("testdata", recursive = TRUE)
})
