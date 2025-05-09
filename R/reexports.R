## nolint start

#' Reexported functions
#' @name reexports
#' @note Updated 2020-07-01.
NULL


## BiocCheck ===================================================================

## Run `BiocCheck::usage()` for options.
## See also r-cmd-check bioc-check script.
## https://github.com/acidgenomics/r-cmd-check/blob/master/checks/bioc-check
##
## Consider including:
## > `no-check-bioc-views` = TRUE,
## > `no-check-coding-practices` = TRUE,
## > `no-check-remotes` = TRUE,

#' @rdname reexports
#' @usage NULL
#' @export
BiocCheck <- function(package = getwd()) {
    stopifnot(.requireNamespaces("BiocCheck"))
    BiocCheck::BiocCheck(
        package = package,
        `new-package` = TRUE,
        `no-check-R-ver` = TRUE,
        `no-check-bioc-help` = TRUE,
        `no-check-version-num` = TRUE,
        `no-check-vignettes` = TRUE
    )
    checkDir <- paste0(normalizePath(package), ".BiocCheck")
    logFile <- file.path(checkDir, "00BiocCheck.log")
    stopifnot(
        dir.exists(checkDir),
        file.exists(logFile)
    )
    lines <- readLines(logFile)
    unlink(checkDir, recursive = TRUE)
    lgl <- grepl(pattern = "* ERROR: ", x = lines)
    if (any(lgl)) {
        errors <- lines[lgl]
        message(paste(errors, collapse = "\n"))
        stop("Errors detected.")
    }
    invisible(lines)
}


## covr ========================================================================

#' @rdname reexports
#' @usage NULL
#' @export
package_coverage <- function(...) {
    stopifnot(.requireNamespaces("covr"))
    covr::package_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
percent_coverage <- function(...) {
    stopifnot(.requireNamespaces("covr"))
    covr::percent_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
report <- function(...) {
    stopifnot(.requireNamespaces(c("DT", "covr")))
    covr::report(...)
}


## devtools ====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
build_vignettes <- function(..., clean = FALSE) {
    stopifnot(.requireNamespaces("devtools"))
    devtools::build_vignettes(..., clean = clean)
}

#' @rdname reexports
#' @usage NULL
#' @export
document <- function(...) {
    stopifnot(.requireNamespaces("devtools"))
    devtools::document(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
load_all <- function(...) {
    stopifnot(.requireNamespaces("pkgload"))
    pkgload::load_all(...)
    invisible(TRUE)
}

## Note that `fresh = TRUE` is currently erroring:
## https://github.com/r-lib/devtools/issues/2264

#' @rdname reexports
#' @usage NULL
#' @export
run_examples <- function(..., document = FALSE) {
    stopifnot(.requireNamespaces("devtools"))
    devtools::run_examples(..., document = document)
}


## lintr =======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
lint <- function(...) {
    stopifnot(.requireNamespaces("lintr"))
    lintr::lint(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
lint_dir <- function(...) {
    stopifnot(.requireNamespaces("lintr"))
    lintr::lint_dir(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
lint_package <- function(...) {
    stopifnot(.requireNamespaces("lintr"))
    lintr::lint_package(...)
}


## pkgdown =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
build_articles <- function(...) {
    stopifnot(.requireNamespaces("pkgdown"))
    pkgdown::build_articles(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_home <- function(...) {
    stopifnot(.requireNamespaces("pkgdown"))
    pkgdown::build_home(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_news <- function(...) {
    stopifnot(.requireNamespaces("pkgdown"))
    pkgdown::build_news(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference <- function(...) {
    stopifnot(.requireNamespaces("pkgdown"))
    pkgdown::build_reference(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference_index <- function(...) {
    stopifnot(.requireNamespaces("pkgdown"))
    pkgdown::build_reference_index(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_site <- function(..., devel = FALSE, preview = FALSE) {
    stopifnot(.requireNamespaces("pkgdown"))
    if (dir.exists("docs")) {
        .unlink2("docs")
    }
    if (dir.exists("reference")) {
        .unlink2("reference")
    }
    pkgdown::build_site(..., devel = devel, preview = preview)
}


## rcmdcheck ===================================================================

## See also:
## - R CMD check --help
## - https://r-pkgs.org/r-cmd-check.html

#' @rdname reexports
#' @usage NULL
#' @export
rcmdcheck <- function(path = getwd(), cran = TRUE) {
    stopifnot(.requireNamespaces("rcmdcheck"))
    Sys.setenv(
        ## See also `force_suggests` argument in `devtools::check()`.
        "_R_CHECK_FORCE_SUGGESTS_" = "FALSE"
    )
    args <- c(
        "--no-manual",
        "--timings"
    )
    if (isTRUE(cran)) {
        args <- c(args, "--as-cran")
    }
    out <- rcmdcheck::rcmdcheck(
        path = path,
        args = args,
        # Time out after 1 hour.
        timeout = 3600L,
        # Alternatively, can be stricter by setting this to "note".
        error_on = Sys.getenv(x = "RCMDCHECK_ERROR_ON", unset = "error")
    )
    stopifnot(identical(out[["status"]], 0L))
    invisible(out)
}


## styler ======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
style_dir <- function(path = getwd()) {
    stopifnot(.requireNamespaces("styler"))
    styler::style_dir(
        path = path,
        style = acid_style
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
style_file <- function(path) {
    stopifnot(.requireNamespaces("styler"))
    styler::style_file(
        path = path,
        style = acid_style
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
style_pkg <- function(pkg = getwd()) {
    stopifnot(.requireNamespaces("styler"))
    styler::style_pkg(
        pkg = pkg,
        style = acid_style
    )
}


## testthat ====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
test_file <- function(...) {
    stopifnot(.requireNamespaces("testthat"))
    testthat::test_file(...)
}


## usethis =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
use_data <- function(..., overwrite = TRUE) {
    stopifnot(.requireNamespaces("usethis"))
    usethis::use_data(..., overwrite = overwrite)
}


## Custom ======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
doc <- function(...) {
    document(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
exit <- function(...) {
    quit(...)
}

## nolint end
