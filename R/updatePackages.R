#' Update all installed packages
#'
#' @export
#' @note Conflicts with `stats::update()`.
#' @note Updated 2019-12-04.
#'
#' @return Invisible `TRUE` or console output.
#'   Whether installation passes Bioconductor validity checks.
#'   See [BiocManager::valid()] for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function() {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    stopifnot(requireNamespace("remotes", quietly = TRUE))
    remotes::update_packages(
        packages = TRUE,
        upgrade = "always",
        repos = BiocManager::repositories()
    )
    BiocManager::install(
        pkgs = character(),
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE
    )
    out <- BiocManager::valid()
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}
