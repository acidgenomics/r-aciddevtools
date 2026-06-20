test_that("valid", {
    skip_if(!nzchar(system.file(package = "BiocManager")))
    skip_if(!nzchar(system.file(package = "goalie")))
    skip_if_not(goalie::hasInternet())
    ## utils::old.packages() may fail in restricted CRAN environments
    ## (e.g. R CMD check with repos = "@CRAN@"). Wrap and skip on error.
    x <- tryCatch(valid(), error = function(e) {
        skip(paste("valid() error:", conditionMessage(e)))
    })
    expect_type(x, "logical")
})
