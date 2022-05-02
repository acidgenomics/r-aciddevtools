#' Package dependencies
#'
#' @export
#' @note Updated 2022-04-29.
#'
#' @param pkg `character(1)`.
#' Package name.
#'
#' @return `character`.
#' Names of dependency packages.
#'
#' @examples
#' ## > packageDependencies("stats")
packageDependencies <- function(pkg) {
    stopifnot(
        requireNamespace("BiocManager", quietly = TRUE),
        requireNamespace("tools", quietly = TRUE),
        is.character(pkg) && identical(length(pkg), 1L)
    )
    repos <- getOption("repos")
    reposBak <- repos
    repos <- append(x = repos, values = BiocManager::repositories())
    options("repos" = repos)
    out <- tools::package_dependencies(
        packages = pkg,
        db = NULL,
        which = c("Depends", "Imports", "LinkingTo"),
        recursive = TRUE,
        reverse = FALSE
    )
    out <- out[[1L]]
    options("repos" = reposBak)
    out
}
