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
    requireNamespaces("BiocCheck")
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
    requireNamespaces("BiocManager")
    BiocManager::valid()
}



## available ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
available <- function(name) {
    requireNamespaces("available")
    available::available(name = name, browse = FALSE)
}



## covr ========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
package_coverage <- function(...) {
    requireNamespaces("covr")
    covr::package_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
percent_coverage <- function(...) {
    requireNamespaces("covr")
    covr::percent_coverage(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
report <- function(...) {
    requireNamespaces(c("DT", "covr"))
    covr::report(...)
}



## devtools ====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
build <- function(..., vignettes = FALSE) {
    requireNamespaces("devtools")
    devtools::build(..., vignettes = vignettes)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_vignettes <- function(..., clean = FALSE) {
    requireNamespaces("devtools")
    devtools::build_vignettes(..., clean = clean)
}

#' @rdname reexports
#' @usage NULL
#' @export
document <- function(...) {
    requireNamespaces("devtools")
    devtools::document(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
load_all <- function() {
    requireNamespaces("devtools")
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
    requireNamespaces("devtools")
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
    requireNamespaces(c("devtools", "testthat", "patrick"))
    devtools::test(...)
}



## gh ==========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
gh <- function(...) {
    requireNamespaces("gh")
    gh::gh(...)
}



## lintr =======================================================================
#' @rdname reexports
#' @usage NULL
#' @export
lint_dir <- function(...) {
    requireNamespaces("lintr")
    lintr::lint_dir(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
lint_package <- function(...) {
    requireNamespaces("lintr")
    lintr::lint_package(...)
}



## magrittr ====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
`%<>%` <- function(...) {
    requireNamespaces("magrittr")
    magrittr::`%<>%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%$%` <- function(...) {
    requireNamespaces("magrittr")
    magrittr::`%$%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%>%` <- function(...) {
    requireNamespaces("magrittr")
    magrittr::`%>%`
}

#' @rdname reexports
#' @usage NULL
#' @export
`%T>%` <- function(...) {
    requireNamespaces("magrittr")
    magrittr::`%T>%`
}



## patrick =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
with_parameters_test_that <- function(...) {
    requireNamespaces("patrick")
    patrick::with_parameters_test_that(...)
}



## pipette ========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
export <- function(...) {
    requireNamespaces("pipette")
    pipette::export(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
import <- function(...) {
    requireNamespaces("pipette")
    pipette::import(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
loadData <- function(...) {
    requireNamespaces("pipette")
    pipette::loadData(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
saveData <- function(...) {
    requireNamespaces("pipette")
    pipette::saveData(...)
}



## pryr ========================================================================
#' @rdname reexports
#' @usage NULL
#' @export
object_size <- function(...) {
    requireNamespaces("pryr")
    pryr::object_size(...)
}



## pkgdown =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
build_articles <- function(...) {
    requireNamespaces("pkgdown")
    pkgdown::build_articles(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_home <- function(...) {
    requireNamespaces("pkgdown")
    pkgdown::build_home(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_news <- function(...) {
    requireNamespaces("pkgdown")
    pkgdown::build_news(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference <- function(...) {
    requireNamespaces("pkgdown")
    pkgdown::build_reference(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_reference_index <- function(...) {
    requireNamespaces("pkgdown")
    pkgdown::build_reference_index(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
build_site <- function(..., devel = FALSE, preview = FALSE) {
    requireNamespaces("pkgdown")
    unlink(file.path("docs", "reference"), recursive = TRUE)
    pkgdown::build_site(..., devel = devel, preview = preview)
}



## rcmdcheck ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
rcmdcheck <- function(path = ".", cran = FALSE) {
    requireNamespaces("rcmdcheck")
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
    requireNamespaces("remotes")
    remotes::download_version(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bioc <- function(...) {
    requireNamespaces("remotes")
    remotes::install_bioc(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_bitbucket <- function(...) {
    requireNamespaces("remotes")
    remotes::install_bitbucket(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_deps <- function(...) {
    requireNamespaces("remotes")
    remotes::install_deps(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_git <- function(...) {
    requireNamespaces("remotes")
    remotes::install_git(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_github <- function(...) {
    requireNamespaces("remotes")
    remotes::install_github(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_gitlab <- function(...) {
    requireNamespaces("remotes")
    remotes::install_gitlab(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
install_url <- function(...) {
    requireNamespaces("remotes")
    remotes::install_url(...)
}



## reticulate ==================================================================
#' @rdname reexports
#' @usage NULL
#' @export
py_config <- function(...) {
    requireNamespaces("reticulate")
    reticulate::py_config(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
py_module_available <- function(...) {
    requireNamespaces("reticulate")
    reticulate::py_module_available(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
use_virtualenv <- function(...) {
    requireNamespaces("reticulate")
    reticulate::use_virtualenv(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
virtualenv_list <- function(...) {
    requireNamespaces("reticulate")
    reticulate::virtualenv_list(...)
}



## rmarkdown ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
render <- function(...) {
    requireNamespaces("rmarkdown")
    rmarkdown::render(...)
}



## syntactic ===================================================================
#' @rdname reexports
#' @usage NULL
#' @export
camelCase <- function(...) {
    requireNamespaces("syntactic")
    syntactic::camelCase(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
kebabCase <- function(...) {
    requireNamespaces("syntactic")
    syntactic::kebabCase(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
makeNames <- function(...) {
    requireNamespaces("syntactic")
    syntactic::makeNames(...)
}

#' @rdname reexports
#' @usage NULL
#' @export
snakeCase <- function(...) {
    requireNamespaces("syntactic")
    syntactic::snakeCase(...)
}



## testthat ====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
test_file <- function(...) {
    requireNamespaces("testthat")
    testthat::test_file(...)
}



## usethis =====================================================================
#' @rdname reexports
#' @usage NULL
#' @export
use_data <- function(..., overwrite = TRUE) {
    requireNamespaces("usethis")
    usethis::use_data(..., overwrite = overwrite)
}



## Custom ======================================================================
#' @rdname reexports
#' @usage NULL
#' @export
check <- function(path = ".", cran = FALSE) {
    requireNamespaces("desc")
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
    requireNamespaces("devtools")
    devtools::install(..., dependencies = dependencies)
}

#' @rdname reexports
#' @usage NULL
#' @export
doc <- function(...) {
    document(...)
}



## nolint end
