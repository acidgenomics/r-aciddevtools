testlib <- file.path(tempdir(), "testlib")

test_that("tag", {
    unlink(testlib, recursive = TRUE)
    pkgName <- "goalie"
    repo <- paste0("acidgenomics/r-", pkgName)
    tag <- "v0.5.4"
    installFromGitHub(
        repo = repo,
        tag = tag,
        lib = testlib,
        reinstall = TRUE
    )
    expect_true(all(
        pkgName %in%
            list.dirs(
                path = testlib,
                full.names = FALSE,
                recursive = FALSE
            )
    ))
    expect_message(
        object = installFromGitHub(
            repo = repo,
            tag = tag,
            lib = testlib,
            reinstall = FALSE
        ),
        regexp = "is installed"
    )
    unlink(testlib, recursive = TRUE)
})

test_that("branch", {
    unlink(testlib, recursive = TRUE)
    pkgName <- "goalie"
    repo <- paste0("acidgenomics/r-", pkgName)
    branch <- "main"
    installFromGitHub(
        repo = repo,
        branch = branch,
        lib = testlib,
        reinstall = TRUE
    )
    expect_true(all(
        pkgName %in%
            list.dirs(
                path = testlib,
                full.names = FALSE,
                recursive = FALSE
            )
    ))
    expect_message(
        object = installFromGitHub(
            repo = repo,
            branch = branch,
            lib = testlib,
            reinstall = FALSE
        ),
        regexp = "is installed"
    )
    unlink(testlib, recursive = TRUE)
})

test_that("scalar branch with multiple repositories", {
    repo <- c("acidgenomics/r-goalie", "acidgenomics/r-goalie")
    branch <- "main"
    out <- installFromGitHub(
        repo = repo,
        branch = branch,
        lib = testlib,
        reinstall = FALSE
    )
    expect_length(out[["installed"]], 2L)
    unlink(testlib, recursive = TRUE)
})
