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

#' @rdname reexports
#' @usage NULL
#' @export
BiocCheck <- function(package = getwd()) {
    stopifnot(requireNamespace("BiocCheck", quietly = TRUE))
    BiocCheck::BiocCheck(
        package = package,
        `new-package` = TRUE,
        `no-check-R-ver` = TRUE,
        `no-check-bioc-help` = TRUE,
        `no-check-bioc-views` = TRUE,
        `no-check-coding-practices` = TRUE,
        `no-check-remotes` = TRUE,
        `no-check-version-num` = TRUE,
        `no-check-vignettes` = TRUE
    )
}



## covr ========================================================================

#' @rdname reexports
#' @usage NULL
#' @export
package_coverage <- function(...) {
    stopifnot(requireNamespace("covr", quietly = TRUE))
    covr::package_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
percent_coverage <- function(...) {
    stopifnot(requireNamespace("covr", quietly = TRUE))
    covr::percent_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
report <- function(...) {
    stopifnot(
        requireNamespace("DT", quietly = TRUE),
        requireNamespace("covr", quietly = TRUE)
    )
    covr::report(...)
}



## devtools ====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
build_vignettes <- function(..., clean = FALSE) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::build_vignettes(..., clean = clean)
}

#' @rdname reexports
#' @usage NULL
#' @export
document <- function(...) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::document(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
load_all <- function(...) {
    stopifnot(requireNamespace("pkgload", quietly = TRUE))
    pkgload::load_all(...)
    invisible(TRUE)
}

## Note that `fresh = TRUE` is currently erroring:
## https://github.com/r-lib/devtools/issues/2264

#' @rdname reexports
#' @usage NULL
#' @export
run_examples <- function(..., document = FALSE) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::run_examples(..., document = document)
}




## formatR =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
tidy_dir <- function(path = getwd(),
                     recursive = TRUE) {
    stopifnot(requireNamespace("formatR", quietly = TRUE))
    formatR::tidy_dir(
        path = path,
        recursive = recursive
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
tidy_file <- function(file) {
    stopifnot(requireNamespace("formatR", quietly = TRUE))
    formatR::tidy_file(file = file)
}



## gh ==========================================================================

#' @rdname reexports
#' @usage NULL
#' @export
gh <- function(...) {
    stopifnot(requireNamespace("gh", quietly = TRUE))
    gh::gh(...)
}



## lintr =======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
lint <- function(...) {
    stopifnot(requireNamespace("lintr", quietly = TRUE))
    lintr::lint(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
lint_dir <- function(...) {
    stopifnot(requireNamespace("lintr", quietly = TRUE))
    lintr::lint_dir(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
lint_package <- function(...) {
    stopifnot(requireNamespace("lintr", quietly = TRUE))
    lintr::lint_package(...)
}



## pipette =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
loadData <- function(...) {
    stopifnot(requireNamespace("pipette", quietly = TRUE))
    pipette::loadData(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
saveData <- function(...) {
    stopifnot(requireNamespace("pipette", quietly = TRUE))
    pipette::saveData(...)
}



## pkgdown =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
build_articles <- function(...) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
    pkgdown::build_articles(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_home <- function(...) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
    pkgdown::build_home(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_news <- function(...) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
    pkgdown::build_news(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference <- function(...) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
    pkgdown::build_reference(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference_index <- function(...) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
    pkgdown::build_reference_index(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_site <- function(..., devel = FALSE, preview = FALSE) {
    stopifnot(requireNamespace("pkgdown", quietly = TRUE))
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
    stopifnot(requireNamespace("rcmdcheck", quietly = TRUE))
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
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::download_version(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bioc <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_bioc(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bitbucket <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_bitbucket(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_deps <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_deps(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_git <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_git(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_github <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_github(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_gitlab <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_gitlab(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_url <- function(...) {
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::install_url(...)
}



## reticulate ==================================================================

#' @rdname reexports
#' @usage NULL
#' @export
py_config <- function(...) {
    stopifnot(requireNamespace("reticulate", quietly = TRUE))
    reticulate::py_config(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
py_module_available <- function(...) {
    stopifnot(requireNamespace("reticulate", quietly = TRUE))
    reticulate::py_module_available(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
use_virtualenv <- function(...) {
    stopifnot(requireNamespace("reticulate", quietly = TRUE))
    reticulate::use_virtualenv(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
virtualenv_list <- function(...) {
    stopifnot(requireNamespace("reticulate", quietly = TRUE))
    reticulate::virtualenv_list(...)
}



## rmarkdown ===================================================================

#' @rdname reexports
#' @usage NULL
#' @export
render <- function(...) {
    stopifnot(requireNamespace("rmarkdown", quietly = TRUE))
    rmarkdown::render(...)
}




## styler ======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
style_dir <- function(path = getwd()) {
    stopifnot(requireNamespace("styler", quietly = TRUE))
    styler::style_dir(
        path = path,
        style = acid_style
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
style_file <- function(path) {
    stopifnot(requireNamespace("styler", quietly = TRUE))
    styler::style_file(
        path = path,
        style = acid_style
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
style_pkg <- function(pkg = getwd()) {
    stopifnot(requireNamespace("styler", quietly = TRUE))
    styler::style_pkg(
        pkg = pkg,
        style = acid_style
    )
}



## syntactic ===================================================================

#' @rdname reexports
#' @usage NULL
#' @export
camelCase <- function(...) {
    stopifnot(requireNamespace("syntactic", quietly = TRUE))
    syntactic::camelCase(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
kebabCase <- function(...) {
    stopifnot(requireNamespace("syntactic", quietly = TRUE))
    syntactic::kebabCase(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
makeNames <- function(...) {
    stopifnot(requireNamespace("syntactic", quietly = TRUE))
    syntactic::makeNames(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
snakeCase <- function(...) {
    stopifnot(requireNamespace("syntactic", quietly = TRUE))
    syntactic::snakeCase(...)
}



## testthat ====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
test_file <- function(...) {
    stopifnot(requireNamespace("testthat", quietly = TRUE))
    testthat::test_file(...)
}



## tibble ======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
view <- function(...) {
    stopifnot(requireNamespace("tibble", quietly = TRUE))
    tibble::view(...)
}



## usethis =====================================================================

#' @rdname reexports
#' @usage NULL
#' @export
use_data <- function(..., overwrite = TRUE) {
    stopifnot(requireNamespace("usethis", quietly = TRUE))
    usethis::use_data(..., overwrite = overwrite)
}



## Custom ======================================================================

#' @rdname reexports
#' @usage NULL
#' @export
devinstall <- function(..., dependencies = FALSE) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::install(..., dependencies = dependencies)
}

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
