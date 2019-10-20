## nolint start



#' Reexported functions
#'
#' Intended for use inside Rprofile internal env.
#'
#' @name reexports
#' @note Updated 2019-10-20.
NULL



## BiocCheck ===================================================================
## Run `BiocCheck::usage()` for options.
## See also Rcheck bioc-check script.
## https://github.com/acidgenomics/Rcheck/blob/master/checks/bioc-check

#' @rdname reexports
#' @usage NULL
#' @export
BiocCheck <- function(package = ".", ...) {
    stopifnot(requireNamespace("BiocCheck", quietly = TRUE))
    BiocCheck::BiocCheck(
        package = package,
        `no-check-R-ver` = TRUE,
        `no-check-bioc-help` = TRUE,
        `no-check-coding-practices` = TRUE,
        `no-check-remotes` = TRUE,
        `no-check-version-num` = TRUE,
        `no-check-vignettes` = TRUE,
        ...
    )
}



## BiocManager =================================================================
#' @rdname reexports
#' @usage NULL
#' @export
valid <- function(...) {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    BiocManager::valid(...)
}



## available ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
available <- function() {
    stopifnot(requireNamespace("available", quietly = TRUE))
    available::available()
}



## brio ========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
loadData <- function(...) {
    stopifnot(requireNamespace("brio", quietly = TRUE))
    brio::loadData(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
saveData <- function(...) {
    stopifnot(requireNamespace("brio", quietly = TRUE))
    brio::saveData(...)
}



## covr ========================================================================
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
build <- function(..., vignettes = FALSE) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::build(..., vignettes = vignettes)
}

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
load_all <- function() {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    ## > pkgload::load_all(helpers = FALSE, attach_testthat = FALSE)
    devtools::load_all()
}

## Disabling `run = TRUE` by default.
## Otherwise, this will attempt to run code inside `\dontrun{}` blocks.
## See https://github.com/r-lib/devtools/issues/1990.

#' @rdname reexports
#' @usage NULL
#' @export
run_examples <- function(
    ...,
    document = FALSE,
    fresh = TRUE,
    run = FALSE,
    test = FALSE
) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::run_examples(
        ...,
        document = document,
        fresh = fresh,
        run = run,
        test = test
    )
}

#' @rdname reexports
#' @usage NULL
#' @export
test <- function(...) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    requireNamespace("testthat")
    requireNamespace("patrick")
    devtools::test(...)
}



## lintr =======================================================================
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



## pkgdown =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
build_articles <- function(...) {
    pkgdown::build_articles(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_home <- function(...) {
    pkgdown::build_home(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_news <- function(...) {
    pkgdown::build_news(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference <- function(...) {
    pkgdown::build_reference(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference_index <- function(...) {
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
#' @rdname reexports
#' @usage NULL
#' @export
rcmdcheck <- function(...) {
    stopifnot(requireNamespace("rcmdcheck", quietly = TRUE))
    rcmdcheck::rcmdcheck(...)
}



## rmarkdown ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
render <- function(...) {
    stopifnot(requireNamespace("rmarkdown", quietly = TRUE))
    rmarkdown::render(...)
}



## usethis =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
use_data <- function(..., overwrite = TRUE) {
    usethis::use_data(..., overwrite = overwrite)
}



## Custom ======================================================================
#' @rdname reexports
#' @usage NULL
#' @export
check <- function() {
    rcmdcheck()
    BiocCheck()
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
devinstall <- function(..., dependencies = FALSE) {
    stopifnot(requireNamespace("devtools", quietly = TRUE))
    devtools::install(..., dependencies = dependencies)
}



## nolint end
