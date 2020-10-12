#' Update all installed packages
#'
#' @export
#' @note Updated 2020-10-12.
#'
#' @return Invisible `TRUE` or console output.
#'   Whether installation passes Bioconductor validity checks.
#'   See [BiocManager::valid()] for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function() {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    ## Clean up CRAN removals and abandoned GitHub packages first.
    suppressMessages({
        uninstall(
            pkgs = c(
                "SDMTools",
                "bioverbs",
                "freerange",
                "pfgsea",
                "transformer"
            )
        )
    })
    message("Updating Bioconductor and CRAN packages.")
    BiocManager::install(
        pkgs = character(),
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE
    )
    if (isTRUE(nzchar(Sys.getenv("GITHUB_PAT")))) {
        message("Updating GitHub packages.")
        stopifnot(requireNamespace("remotes", quietly = TRUE))
        suppressMessages({
            remotes::update_packages(
                packages = TRUE,
                upgrade = "always",
                repos = BiocManager::repositories()
            )
        })
    }
    out <- BiocManager::valid()
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}
