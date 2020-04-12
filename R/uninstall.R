#' Uninstall a package
#'
#' Wrapper for `utils::remove.packages()`.
#'
#' @inheritParams params
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @return Invisible `character`.
#'   Names of packages that were removed.
#'
#' @examples
#' ## > uninstall("bb8")
uninstall <- function(pkgs) {
    installed <- rownames(installed.packages())
    remove <- intersect(pkgs, installed)
    skip <- setdiff(pkgs, installed)
    if (hasLength(skip)) {
        message(sprintf("Skipping packages: %s", toString(skip)))
    }
    if (hasLength(remove)) {
        message(sprintf("Removing packages: %s", toString(remove)))
        remove.packages(remove)
    }
    invisible(remove)
}
