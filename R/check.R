#' Check package
#'
#' @export
#' @note Updated 2021-05-18.
#'
#' @param path `character(1)`.
#'   Directory path to package.
#' @param cran `logical(1)`.
#'   Perform additional CRAN submission checks.
#' @param biocCheck `logical(1)`.
#'   Perform additional Bioconductor checks.
#' @param coverage `logical(1)`.
#'   Check that unit tests provide sufficient coverage.
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
    if (isTRUE(coverage)) {
        .checkCoverage(path = path)
    }
    invisible(TRUE)
}



#' Check package coverage using covr
#'
#' @note Updated 2021-06-04.
#' @noRd
.checkCoverage <- function(
    path = ".",
    cutoff = 0.80
) {
    if (!dir.exists("tests")) {
        message("No unit tests defined in 'tests' directory.")
        return(invisible(FALSE))
    }
    message("Checking coverage with covr package.")
    pctCutoff <- cutoff * 100L
    if (isTRUE(nzchar(Sys.getenv("RCHECK_KEEP_IT_100")))) {
        ## covr sometimes reports 99.8% coverage instead of 100%.
        pctCutoff <- 99L
        message("Requiring 100% coverage.")
    }
    cov <- package_coverage(path = path)
    pct <- percent_coverage(cov)
    print(cov)
    if (pct < pctCutoff) {
        stop(sprintf("Coverage is %s%%.", round(pct, digits = 2L)))
    }
    invisible(TRUE)
}
