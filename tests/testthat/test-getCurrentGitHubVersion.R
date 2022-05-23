test_that("r-lib", {
    repo <- paste0("r-lib/", c("rlang", "testthat"))
    x <- getCurrentGitHubVersion(repo)
    expect_s3_class(x, "package_version")
})
