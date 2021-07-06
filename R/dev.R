#' Attach developer packages
#'
#' @export
#' @note Updated 2021-07-06.
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
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        is.logical(quiet) && identical(length(quiet), 1L)
    )
    ## Order is important here.
    pkgs <- c(
        "magrittr",
        "rlang",
        "tidyselect",
        "devtools",
        "testthat",
        "goalie",
        "basejump",
        "SummarizedExperiment",
        "SingleCellExperiment",
        "tidyverse"
    )
    ## Stop on missing packages.
    installed <- rownames(utils::installed.packages())
    notInstalled <- setdiff(pkgs, installed)
    if (length(notInstalled) > 0L) {
        stop(sprintf("Not installed: %s.", toString(notInstalled)))
    }
    ## Attach unloaded deps.
    attached <- lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!pkg %in% (.packages())) {
                if (isTRUE(quiet)) {
                    suppressPackageStartupMessages({
                        attachNamespace(pkg)
                    })
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
