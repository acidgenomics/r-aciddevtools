#' Execute test_that tests in a package
#'
#' @export
#' @note Updated 2021-07-06.
#'
#' @inheritParams params
#'
#' @return Invisible `TRUE` on success, otherwise error.
#'
#' @examples
#' ## > test()
test <- function(
    path = ".",
    coverage = TRUE
) {
    path <- normalizePath(path = path, mustWork = TRUE)
    testsDir <- file.path(path, "tests", "testthat")
    if (!isTRUE(dir.exists(testsDir))) {
        message(sprintf(
            "No testthat unit tests defined in '%s'.",
            testsDir
        ))
        return(invisible(FALSE))
    }
    stopifnot(
        requireNamespace("devtools", quietly = TRUE),
        requireNamespace("testthat", quietly = TRUE)
    )
    devtools::load_all(
        path = path,
        reset = TRUE,
        helpers = TRUE,
        quiet = TRUE
    )
    options("testthat.progress.max_fails" = 1L)
    devtools::test(
        pkg = path,
        stop_on_failure = TRUE
    )
    ## Alternative approach:
    ## > testthat::test_dir(
    ## >     path = testsDir,
    ## >     load_helpers = TRUE,
    ## >     stop_on_failure = TRUE,
    ## >     stop_on_warning = TRUE
    ## > )
    if (isTRUE(coverage)) {
        .checkCoverage(path = path)
        ## Alternative approach:
        ## > stopifnot(requireNamespace("covr", quietly = TRUE))
        ## > devtools::test_coverage(
        ## >     pkg = path,
        ## >     show_report = interactive()
        ## > )
    }
    invisible(TRUE)
}
