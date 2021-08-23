context("getCurrentGitHubVersion")

test_that("r-lib", {
    repo <- paste0("r-lib/", c("rlang", "testthat"))
    x <- getCurrentGitHubVersion(repo)
    expect_is(x, "package_version")
})
