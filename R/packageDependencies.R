#' Package dependencies
#'
#' @export
#' @note Updated 2022-10-20.
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
        .requireNamespaces(c("BiocManager", "tools", "withr")),
        .isString(pkg)
    )
    withr::with_options(
        new = list(
            "repos" = append(
                x = getOption("repos"),
                values = BiocManager::repositories()
            )
        ),
        code = {
            out <- tools::package_dependencies(
                packages = pkg,
                db = NULL,
                which = c("Depends", "Imports", "LinkingTo"),
                recursive = TRUE,
                reverse = FALSE
            )
            out <- out[[1L]]
            out
        }
    )
}
