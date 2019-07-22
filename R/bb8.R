#' bb8
#'
#' Trusty sidekick for R package development.
#'
#' @return Invisible character vector of packages attached specifically by
#'   this function call.
#'
#' @export
#' @examples
#' \dontrun{
#' bb8()
#' }
bb8 <- function() {
    path <- find.package("bb8")
    deps <- desc_get_deps(path)

    ## Note that we're only attaching the suggested packages here.
    ## Order is important. Note that the last item specified in "Suggests" in
    ## DESCRIPTION file will take priority in the NAMESPACE.
    pkgs <- deps[deps[["type"]] == "Suggests", "package", drop = TRUE]

    ## Stop on missing deps.
    notInstalled <- setdiff(pkgs, rownames(installed.packages()))
    if (length(notInstalled) > 0L) {
        stop(paste("Not installed:", toString(notInstalled)), call. = FALSE)
    }

    ## Attach unloaded deps.
    attached <- lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!pkg %in% (.packages())) {
                suppressPackageStartupMessages(attachNamespace(pkg))
                pkg
            }
        })
    attached <- unlist(attached)

    ## Invisibly return information on attached packages.
    invisible(attached)
}
