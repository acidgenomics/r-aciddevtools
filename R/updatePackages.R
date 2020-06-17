#' Update all installed packages
#'
#' @export
#' @note Conflicts with `stats::update()`.
#' @note Updated 2020-06-17.
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
