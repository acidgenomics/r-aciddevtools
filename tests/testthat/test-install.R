context("install")

testlib <- "testlib"

test_that("BiocManager", {
    unlink(testlib, recursive = TRUE)
    dir.create(testlib)
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
    unlink(testlib, recursive = TRUE)
})

test_that("Acid Genomics drat repo", {
    unlink(testlib, recursive = TRUE)
    dir.create(testlib)
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
    dir.create(testlib)
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
    dir.create(testlib)
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



context("installGitHub")

test_that("GitHub", {
    unlink(testlib, recursive = TRUE)
    dir.create(testlib)
    pkgName <- "goalie"
    repo <- paste0("acidgenomics/r-", pkgName)
    tag <- "v0.5.4"
    installGitHub(
        repo = repo,
        tag = tag,
        lib = testlib,
        reinstall = TRUE
    )
    expect_true(all(
        pkgName %in% list.dirs(
            path = testlib,
            full.names = FALSE,
            recursive = FALSE
        )
    ))
    expect_message(
        object = installGitHub(
            repo = repo,
            tag = tag,
            lib = testlib,
            reinstall = FALSE
        ),
        regexp = "is installed"
    )
    unlink(testlib, recursive = TRUE)
})
