test_that("r-lib", {
    ## nolint start
    repo <- paste(
        "r-lib",
        c("rlang", "testthat"),
        sep = "/"
    )
    ## nolint end
    x <- getCurrentGitHubVersion(repo)
    expect_s3_class(x, "package_version")
})
