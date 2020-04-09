#' Attach developer packages
#'
#' @export
#' @note Updated 2020-04-09.
#'
#' @param quiet `logical(1)`.
#'   Load packages quietly.
#'
#' @return Invisible character vector of packages attached specifically by
#'   this function call.
#'
#' @examples
#' ## Load the developer environment.
#' ## > dev()
dev <- function(quiet = TRUE) {
    requireNamespaces("utils")
    assert(isFlag(quiet))
    ## Order is important here.
    pkgs <- c(
        "SummarizedExperiment",
        "SingleCellExperiment",
        "Rcpp",
        "rlang",
        "R.utils",
        "magrittr",
        "scales",
        "devtools",
        "knitr",
        "lintr",
        "pkgdown",
        "covr",
        "testthat",
        "patrick",
        "goalie",
        "basejump",
        "tidyselect",
        "tidyverse"
    )
    ## Stop on missing packages.
    installed <- rownames(utils::installed.packages())
    notInstalled <- setdiff(pkgs, installed)
    if (hasLength(notInstalled)) {
        stop(sprintf("Not installed: %s.", toString(notInstalled)))
    }
    ## Attach unloaded deps.
    attached <- lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!pkg %in% (.packages())) {
                if (isTRUE(quiet)) {
                    suppressPackageStartupMessages(
                        attachNamespace(pkg)
                    )
                } else {
                    attachNamespace(pkg)
                }
                pkg
            }
        })
    attached <- unlist(attached)
    ## Invisibly return information on attached packages.
    invisible(attached)
}
