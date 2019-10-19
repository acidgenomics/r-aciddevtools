#' Update all installed packages
#'
#' @export
#' @note Conflicts with `stats::update()`.
#' @note Updated 2019-10-19.
#'
#' @return Invisible `logical(1)`.
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
        dependencies = TRUE,
        upgrade = "always",
        repos = BiocManager::repositories()
    )
    BiocManager::install(
        pkgs = character(),
        dependencies = TRUE,
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE
    )
    out <- BiocManager::valid()
    invisible(out)
}
