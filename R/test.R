## nocov start

#' Execute test_that tests in a package
#'
#' @export
#' @note Updated 2023-08-10.
#'
#' @details
#' Note that usage of `test_local` is now recommended instead of `test_dir`,
#' and appears to be required for testthat checks to run successfully in
#' parallel.
#'
#' @inheritParams params
#'
#' @return Invisible `TRUE` on success, otherwise error.
#'
#' @seealso
#' - https://github.com/r-lib/testthat/issues/1216
#'
#' @examples
#' ## > test()
test <- function(path = getwd()) {
    path <- .realpath(path)
    testsDir <- file.path(path, "tests", "testthat")
    if (!isTRUE(dir.exists(testsDir))) {
        message(sprintf(
            "No testthat unit tests defined in '%s'.",
            testsDir
        ))
        return(invisible(FALSE))
    }
    stopifnot(.requireNamespaces(c("testthat", "pkgload")))
    maxFails <- getOption("testthat.progress.max_fails")
    options("testthat.progress.max_fails" = 1L) # nolint
    out <- testthat::test_local(
        path = testsDir,
        load_helpers = TRUE,
        stop_on_failure = TRUE,
        stop_on_warning = TRUE
    )
    stopifnot(
        "Unit test failure detected." = {
            isTRUE(length(out[[length(out)]][["results"]]) > 0L)
        }
    )
    options("testthat.progress.max_fails" = maxFails) # nolint
    invisible(out)
}

## nocov end
