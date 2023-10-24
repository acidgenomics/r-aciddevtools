## nocov start

#' Execute testthat tests in a package
#'
#' @export
#' @note Updated 2023-09-28.
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
#' - https://contributions.bioconductor.org/long-tests.html
#' - https://github.com/r-lib/testthat/issues/1216
#'
#' @examples
#' ## > test()
test <- function(path = getwd()) {
    stopifnot(.isADir(path))
    path <- .realpath(path)
    testsDir <- file.path(path, "tests", "testthat")
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
    message(sprintf("Running testthat tests in '%s'.", testsDir))
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
longtest <- function(path = getwd()) {
    testsDir <- file.path(path, "longtests", "testthat")
    if (!.isADir(testsDir)) {
        message(sprintf(
            "No testthat unit tests defined in '%s'.",
            testsDir
        ))
        return(invisible(FALSE))
    }
    stopifnot(.requireNamespaces("AcidBase"))
    message(sprintf("Running long tests in '%s'.", testsDir))
    tmpdir <- AcidBase::tempdir2()
    invisible(file.copy(
        from = path,
        to = tmpdir,
        overwrite = TRUE,
        recursive = TRUE
    ))
    path2 <- file.path(tmpdir, basename(path))
    .unlink2(file.path(path2, "tests"))
    file.rename(
        from = file.path(path2, "longtests"),
        to = file.path(path2, "tests")
    )
    test(path = path2)
    .unlink2(tmpdir)
    invisible(TRUE)
}

## nocov end
