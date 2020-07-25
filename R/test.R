#' Execute test_that tests in a package
#' @note Updated 2020-07-25.
#' @export
test <- function() {
    testsDir <- file.path("tests", "testthat")
    stopifnot(
        dir.exists(testsDir),
        requireNamespace("devtools", quietly = TRUE),
        requireNamespace("testthat", quietly = TRUE),
        requireNamespace("patrick", quietly = TRUE)
    )
    devtools::load_all()
    testthat::test_dir(
        path = testsDir,
        load_helpers = TRUE,
        stop_on_failure = TRUE,
        stop_on_warning = TRUE
    )
}
