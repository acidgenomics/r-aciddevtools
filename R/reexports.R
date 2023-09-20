## nocov start
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
## > `no-check-vignettes` = TRUE

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
        `no-check-version-num` = TRUE
    )
    ## FIXME This needs to stop on error.
    ## FIXME This needs to clean up BiocCheck folder on success.
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
    unlink(file.path("docs", "reference"), recursive = TRUE)
    pkgdown::build_site(..., devel = devel, preview = preview)
}



## rcmdcheck ===================================================================

## See also:
## - R CMD check --help
## - https://r-pkgs.org/r-cmd-check.html

#' @rdname reexports
#' @usage NULL
#' @export
rcmdcheck <- function(path = getwd(),
                      cran = FALSE) {
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
        error_on = Sys.getenv(x = "RCMDCHECK_ERROR_ON", unset = "warning")
    )
    stopifnot(identical(out[["status"]], 0L))
    invisible(out)
}



## remotes =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
download_version <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::download_version(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bioc <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_bioc(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bitbucket <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_bitbucket(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_deps <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_deps(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_git <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_git(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_github <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_github(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_gitlab <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_gitlab(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_url <- function(...) {
    stopifnot(.requireNamespaces("remotes"))
    remotes::install_url(...)
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
## nocov end
