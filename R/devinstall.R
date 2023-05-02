#' Install package in development
#'
#' @export
#'
#' @param pkg `character(1)`.
#' Package directory path.
#'
#' @param dependencies `logical(1)`.
#' Also include dependencies.
#' Use `TRUE` to also install all suggested packages.
#'
#' @return Invisible `character(1)`.
#' Package directory path
devinstall <- function(pkg = getwd(), dependencies = FALSE) {
    stopifnot(
        .requireNamespaces("devtools"),
        isTRUE(dir.exists(pkg))
    )
    repos <- getOption("repos")
    if (!isFALSE(dependencies)) {
        stopifnot(.requireNamespaces("BiocManager"))
        options("repos" = BiocManager::repositories()) # nolint
    }
    devtools::install(pkg, dependencies = dependencies)
    options("repos" = repos) # nolint
    invisible(pkg)
}
