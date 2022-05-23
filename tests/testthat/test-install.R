testlib <- file.path(tempdir(), "testlib")

test_that("BiocManager", {
    unlink(testlib, recursive = TRUE)
    pkgs <- "BiocGenerics"
    install(
        pkgs = pkgs,
        lib = testlib,
        dependencies = FALSE,
        reinstall = TRUE
    )
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
    uninstall(
        pkgs = pkgs,
        lib = testlib
    )
    expect_false(all(
        pkgs %in% list.dirs(
            path = testlib,
            full.names = FALSE,
            recursive = FALSE
        )
    ))
    unlink(testlib, recursive = TRUE)
})

test_that("Acid Genomics drat repo", {
    unlink(testlib, recursive = TRUE)
    pkgs <- "goalie"
    install(
        pkgs = pkgs,
        lib = testlib,
        dependencies = FALSE,
        reinstall = TRUE
    )
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
    unlink(testlib, recursive = TRUE)
})

test_that("Git repo", {
    unlink(testlib, recursive = TRUE)
    pkgNames <- "goalie"
    pkgs <- paste0("https://github.com/acidgenomics/r-", pkgNames, ".git")
    install(
        pkgs = pkgs,
        lib = testlib,
        dependencies = FALSE,
        reinstall = TRUE
    )
    expect_true(all(
        pkgNames %in% list.dirs(
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
    unlink(testlib, recursive = TRUE)
})

test_that("GitHub", {
    unlink(testlib, recursive = TRUE)
    pkgNames <- "goalie"
    pkgs <- paste0("acidgenomics/r-", pkgNames)
    install(
        pkgs = pkgs,
        lib = testlib,
        dependencies = FALSE,
        reinstall = TRUE
    )
    expect_true(all(
        pkgNames %in% list.dirs(
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
    unlink(testlib, recursive = TRUE)
})
