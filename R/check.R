#' Check package
#'
#' @export
#' @note Updated 2021-08-20.
#'
#' @inheritParams params
#'
#' @param lints `logical(1)`.
#'   Perform `lintr::lint_package()` checks.
#' @param urls `logical(1)`.
#'   Perform `urlchecker::url_check()` checks.
#' @param cran `logical(1)`.
#'   Perform additional CRAN submission checks.
#' @param biocCheck `logical(1)`.
#'   Perform additional Bioconductor checks. `BiocCheck` is only called when we
#'   detect `"biocViews"` metadata in `DESCRIPTION` file, and when the directory
#'   name is identical to the package name. `BiocCheck` currently errors on
#'   directory names that differ from package name.
#'
#' @return `TRUE` on success, otherwise error.
#'
#' @examples
#' ## > check()
check <- function(
    path = ".",
    lints = TRUE,
    urls = TRUE,
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
    if (isTRUE(lints) && .isInstalled("lintr")) {
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
    if (isTRUE(urls) && .isInstalled("urlchecker")) {
        stopifnot(requireNamespace("urlchecker", quietly = TRUE))
        message("Checking URLs with 'urlchecker::url_check()'.")
        urlchecker::url_check(path = path)
    }
    message("Running package checks with 'rcmdcheck()'.")
    rcmdcheck(path = path, cran = cran)
    test(path = path)
    if (isTRUE(coverage)) {
        .checkCoverage(path = path)
    }
    if (isTRUE(biocCheck)) {
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
