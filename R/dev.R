#' Attach developer packages
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @param quiet `logical(1)`.
#'   Load packages quietly.
#'
#' @return Invisible character vector of packages attached specifically by
#'   this function call.
#'
#' @examples
#' ## Load the developer environment.
#' ## > bb8()
dev <- function(quiet = TRUE) {
    path <- find.package("bb8")
    deps <- desc_get_deps(path)

    ## Note that we're only attaching the suggested packages here.
    ## Order is important. Note that the last item specified in "Suggests" in
    ## DESCRIPTION file will take priority in the NAMESPACE.
    pkgs <- deps[deps[["type"]] == "Suggests", "package", drop = TRUE]

    ## Stop on missing deps.
    notInstalled <- setdiff(pkgs, rownames(installed.packages()))
    if (length(notInstalled) > 0L) {
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
