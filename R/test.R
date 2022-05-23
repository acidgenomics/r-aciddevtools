## nocov start



#' Execute test_that tests in a package
#'
#' @export
#' @note Updated 2021-08-20.
#'
#' @inheritParams params
#'
#' @return Invisible `TRUE` on success, otherwise error.
#'
#' @examples
#' ## > test()
test <- function(path = getwd()) {
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
        requireNamespace("testthat", quietly = TRUE),
        requireNamespace("pkgload", quietly = TRUE)
    )
    maxFails <- getOption(x = "testthat.progress.max_fails")
    options("testthat.progress.max_fails" = 1L) # nolint
    out <- testthat::test_dir(
        path = testsDir,
        load_helpers = TRUE,
        load_package = "source",
        stop_on_failure = TRUE,
        stop_on_warning = TRUE
    )
    stopifnot(
        "Unit test failure detected." =
            isTRUE(length(out[[length(out)]][["results"]]) > 0L)
    )
    options("testthat.progress.max_fails" = maxFails) # nolint
    invisible(out)
}



## nocov end
