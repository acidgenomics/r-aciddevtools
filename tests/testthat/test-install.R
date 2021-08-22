context("install")

testlib <- "testlib"
unlink(testlib, recursive = TRUE)
dir.create(testlib)

test_that("BiocManager", {
    pkgs <- "BiocGenerics"
    out <- install(
        pkgs = pkgs,
        lib = testlib,
        dependencies = FALSE,
        reinstall = TRUE
    )
    expect_identical(basename(out), pkgs)
    expect_true(all(
        pkgs %in% list.dirs(
            path = testlib,
            full.names = FALSE,
            recursive = FALSE
        )
    ))
    expect_message(
        object = install(
            pkgs = pkgs,
            lib = testlib,
            reinstall = FALSE
        ),
        regexp = "is installed"
    )
})

unlink(testlib, recursive = TRUE)
