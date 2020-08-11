#' Update all installed packages
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @return Invisible `TRUE` or console output.
#'   Whether installation passes Bioconductor validity checks.
#'   See [BiocManager::valid()] for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function() {
    stopifnot(
        requireNamespace("BiocManager", quietly = TRUE),
        requireNamespace("remotes", quietly = TRUE)
    )
    ## Clean up CRAN removals and abandoned GitHub packages first.
    suppressMessages({
        uninstall(
            pkgs = c(
                ## "Matrix.utils"
                "SDMTools",
                "bioverbs",
                "brio",
                "freerange",
                "lsei",
                "npsurv",
                "nvimcom",
                "pfgsea",
                "profdpm",
                "purrrogress",
                "robust",
                "transformer"
            )
        )
    })
    BiocManager::install(
        pkgs = character(),
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE
    )
    suppressMessages({
        remotes::update_packages(
            packages = TRUE,
            upgrade = "always",
            repos = BiocManager::repositories()
        )
    })
    out <- BiocManager::valid()
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}
