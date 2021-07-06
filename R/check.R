#' Check package
#'
#' @export
#' @note Updated 2021-07-06.
#'
#' @inheritParams params
#'
#' @param cran `logical(1)`.
#'   Perform additional CRAN submission checks.
#' @param biocCheck `logical(1)`.
#'   Perform additional Bioconductor checks.
#'
#' @return `TRUE` on success, otherwise error.
#'
#' @examples
#' ## > check()
check <- function(
    path = ".",
    cran = FALSE,
    biocCheck = TRUE,
    coverage = TRUE
) {
    stopifnot(
        requireNamespace("desc", quietly = TRUE),
        requireNamespace("rcmdcheck", quietly = TRUE),
        isTRUE(dir.exists(path))
    )
    path <- normalizePath(path, mustWork = TRUE)
    descFile <- file.path(path, "DESCRIPTION")
    keys <- desc::desc_get(keys = c("Package", "biocViews"), file = descFile)
    pkgName <- keys[["Package"]]
    message(sprintf("Checking '%s' package at '%s'.", pkgName, path))
    if (.isInstalled("lintr")) {
        stopifnot(requireNamespace("lintr", quietly = TRUE))
        message("Checking for lints with 'lint_package()'.")
        lints <- lint_package(path = path)
        if (length(lints) > 0L) {
            print(lints)
            stop(sprintf(
                fmt = "Package failed lintr checks. %d %s detected.",
                length(lints),
                ngettext(n = length(lints), msg1 = "lint", msg2 = "lints")
            ))
        }
    }
    if (.isInstalled("urlchecker")) {
        stopifnot(requireNamespace("urlchecker", quietly = TRUE))
        message("Checking URLs with 'urlchecker::url_check()'.")
        urlchecker::url_check(path = path)
    }
    message("Running package checks with 'rcmdcheck()'.")
    rcmdcheck(path = path, cran = cran)
    test(path = path, coverage = coverage)
    if (isTRUE(biocCheck)) {
        ## Only run BiocCheck if we detect "biocViews" in DESCRIPTION and when
        ## the directory name is identical to the package name. BiocCheck
        ## currently errors on directory names that differ from package name.
        ok <- all(
            !is.na(keys[["biocViews"]]),
            identical(pkgName, basename(path)),
            .isInstalled("BiocCheck")
        )
        if (isTRUE(ok)) {
            message("Running Bioconductor checks with 'BiocCheck()'.")
            BiocCheck(package = path)
        }
    }
    invisible(TRUE)
}
