## nocov start

#' Check package
#'
#' @export
#' @note Updated 2023-09-28.
#'
#' @inheritParams params
#'
#' @param lints `logical(1)`.
#' Perform `lintr::lint_package()` checks.
#'
#' @param urls `logical(1)`.
#' Perform `urlchecker::url_check()` checks.
#'
#' @param style `logical(1)`.
#' Perform `styler::style_pkg()` checks.
#'
#' @param cran `logical(1)`.
#' Perform additional CRAN submission checks.
#'
#' @param biocCheck `logical(1)`.
#' Perform additional Bioconductor checks. `BiocCheck` is only called when we
#' detect `"biocViews"` metadata in `DESCRIPTION` file, and when the directory
#' name is identical to the package name. `BiocCheck` currently errors on
#' directory names that differ from package name.
#'
#' @return `TRUE` on success, otherwise error.
#'
#' @examples
#' ## > check()
check <- function(path = getwd(),
                  style = TRUE,
                  lints = TRUE,
                  urls = TRUE,
                  ## CRAN checks seems to have issues with requireNamespace.
                  cran = FALSE,
                  biocCheck = TRUE,
                  coverage = FALSE) {
    stopifnot(
        .requireNamespaces(c("desc", "rcmdcheck")),
        .isADir(path)
    )
    dt <- list()
    dt[["start"]] <- Sys.time()
    path <- .realpath(path)
    descFile <- file.path(path, "DESCRIPTION")
    deps <- desc::desc_get_deps(file = descFile)[["package"]]
    deps <- setdiff(deps, "R")
    if (length(deps) > 0L) {
        ok <- .isInstalled(deps)
        if (!all(ok)) {
            missing <- deps[!ok]
            stop(sprintf("Not installed: %s.", toString(missing)))
        }
    }
    keys <- desc::desc_get(keys = c("Package", "biocViews"), file = descFile)
    pkgName <- keys[["Package"]]
    message(sprintf("Checking '%s' package at '%s'.", pkgName, path))
    if (isTRUE(style) && .isInstalled("styler")) {
        stopifnot(.requireNamespaces("styler"))
        message("Checking style with 'style_pkg()'.")
        df <- style_pkg(pkg = path)
        stopifnot(isFALSE(any(df[["changed"]])))
    }
    if (isTRUE(lints) && .isInstalled("lintr")) {
        stopifnot(.requireNamespaces("lintr"))
        message("Checking for lints with 'lint_package()'.")
        lints <- lint_package(path = path)
        if (.hasLength(lints)) {
            print(lints)
            stop(sprintf(
                fmt = "Package failed lintr checks. %d %s detected.",
                length(lints),
                ngettext(n = length(lints), msg1 = "lint", msg2 = "lints")
            ))
        }
    }
    if (
        isTRUE(urls) &&
            .isInstalled("urlchecker") &&
            .isASystemCommand("pandoc")
    ) {
        stopifnot(.requireNamespaces("urlchecker"))
        message("Checking URLs with 'urlchecker::url_check()'.")
        out <- urlchecker::url_check(path = path)
        print(out)
        ## Allow URL failures to pass through without check failure.
        ## > stopifnot(identical(nrow(out), 0L))
    }
    message("Running package checks with 'rcmdcheck()'.")
    rcmdcheck(path = path, cran = cran)
    ## > test(path = path)
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
    if (isTRUE(coverage)) {
        .checkCoverage(path = path)
    }
    dt[["stop"]] <- Sys.time()
    dt[["duration"]] <- difftime(
        time1 = dt[["stop"]],
        time2 = dt[["start"]],
        units = "auto"
    )
    message(sprintf(
        "Package check completed successfully (%s).",
        format(dt[["duration"]])
    ))
    invisible(TRUE)
}

## nocov end
