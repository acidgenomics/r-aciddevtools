## nolint start



#' Reexported functions
#'
#' Intended for use inside Rprofile internal env.
#'
#' @name reexports
#' @note Updated 2020-04-09.
NULL



## BiocCheck ===================================================================
## Run `BiocCheck::usage()` for options.
## See also Rcheck bioc-check script.
## https://github.com/acidgenomics/Rcheck/blob/master/checks/bioc-check

#' @rdname reexports
#' @usage NULL
#' @export
BiocCheck <- function(package = ".") {
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



## BiocManager =================================================================
#' @rdname reexports
#' @usage NULL
#' @export
valid <- function() {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    BiocManager::valid()
}



## available ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
available <- function(name) {
    stopifnot(requireNamespace("available", quietly = TRUE))
    available::available(name = name, browse = FALSE)
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
    stopifnot(
        requireNamespace("devtools", quietly = TRUE),
        requireNamespace("testthat", quietly = TRUE),
        requireNamespace("patrick", quietly = TRUE)
    )
    devtools::test(...)
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



## magrittr ====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
`%<>%` <- function(...) {
    stopifnot(requireNamespace("magrittr", quietly = TRUE))
    magrittr::`%<>%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%$%` <- function(...) {
    stopifnot(requireNamespace("magrittr", quietly = TRUE))
    magrittr::`%$%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%>%` <- function(...) {
    stopifnot(requireNamespace("magrittr", quietly = TRUE))
    magrittr::`%>%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%T>%` <- function(...) {
    stopifnot(requireNamespace("magrittr", quietly = TRUE))
    magrittr::`%T>%`
}



## patrick =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
with_parameters_test_that <- function(...) {
    stopifnot(requireNamespace("patrick", quietly = TRUE))
    patrick::with_parameters_test_that(...)
}



## pipette =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
export <- function(...) {
    stopifnot(requireNamespace("pipette", quietly = TRUE))
    pipette::export(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
import <- function(...) {
    stopifnot(requireNamespace("pipette", quietly = TRUE))
    pipette::import(...)
}

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



## pryr ========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
object_size <- function(...) {
    stopifnot(requireNamespace("pryr", quietly = TRUE))
    pryr::object_size(...)
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
#' @rdname reexports
#' @usage NULL
#' @export
rcmdcheck <- function(path = ".", cran = FALSE) {
    stopifnot(requireNamespace("rcmdcheck", quietly = TRUE))
    ## See also `force_suggests` argument in `devtools::check()`.
    Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "FALSE")
    args <- "--no-manual"
    if (isTRUE(cran)) {
        args <- c(args, "--as-cran")
    }
    rcmdcheck::rcmdcheck(
        path = path,
        args = args,
        error_on = "note"
    )
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
check <- function(path = ".", cran = FALSE) {
    stopifnot(requireNamespace("desc", quietly = TRUE))
    lint_package()
    rcmdcheck(
        path = path,
        cran = cran
    )
    ## Only run BiocCheck if we detect "biocViews" in DESCRIPTION.
    ok <- !is.na(unname(desc::desc_get(keys = "biocViews", file = path)))
    if (isTRUE(ok)) {
        BiocCheck(path)
    }
}

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



## nolint end
