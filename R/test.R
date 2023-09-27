## nocov start

#' Execute testthat tests in a package
#'
#' @export
#' @note Updated 2023-09-27.
#'
#' @details
#' Note that usage of `test_local` is now recommended instead of `test_dir`,
#' and appears to be required for testthat checks to run successfully in
#' parallel.
#'
#' @inheritParams params
#'
#' @param longtests `logical(1)`.
#' Also run optional long tests in `longtests` directory.
#'
#' @return Invisible `TRUE` on success, otherwise error.
#'
#' @seealso
#' - https://contributions.bioconductor.org/long-tests.html
#' - https://github.com/r-lib/testthat/issues/1216
#'
#' @examples
#' ## > test()
test <- function(path = getwd(), longtests = FALSE) {
    stopifnot(.isADir(path), .isFlag(longtests))
    path <- .realpath(path)
    testsDir <- ifelse(
        test = longtests,
        yes = file.path(path, "longtests", "testthat"),
        no = file.path(path, "tests", "testthat")
    )
    if (!.isADir(testsDir)) {
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
    stopifnot(.is(out, "testthat_results"))
    outDf <- as.data.frame(out)
    stopifnot(
        .isSubset(c("error", "warning"), colnames(outDf)),
        isFALSE(any(outDf[["error"]])),
        identical(sum(outDf[["warning"]]), 0L)
    )
    options("testthat.progress.max_fails" = maxFails) # nolint
    invisible(out)
}



#' @export
#' @rdname test
longtest <- function(...) {
    test(..., longtests = TRUE)
}

## nocov end
