#' Uninstall a package
#'
#' Wrapper for `utils::remove.packages()`.
#'
#' @inheritParams params
#'
#' @export
#' @note Updated 2020-11-04.
#'
#' @return Invisible `character`.
#'   Names of packages that were removed.
#'
#' @examples
#' ## > uninstall("rlang")
uninstall <- function(pkgs) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    ## Treat all warnings as errors.
    warn <- getOption("warn")
    options("warn" = 2L)
    installed <- rownames(utils::installed.packages())
    remove <- intersect(pkgs, installed)
    skip <- setdiff(pkgs, installed)
    if (length(skip) > 0L) {
        message(sprintf("Skipping packages: %s", toString(skip)))
    }
    if (length(remove) > 0L) {
        message(sprintf("Removing packages: %s", toString(remove)))
        utils::remove.packages(remove)
    }
    options("warn" = warn)
    invisible(remove)
}
