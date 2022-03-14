#' Uninstall a package
#'
#' Wrapper for `utils::remove.packages()`.
#'
#' @inheritParams params
#'
#' @export
#' @note Updated 2021-08-22.
#'
#' @return Invisible `list`.
#' Metadata containing names of packages that were removed, and the package
#' library path.
#'
#' @examples
#' ## > uninstall("rlang")
uninstall <- function(pkgs, lib = .libPaths()[[1L]]) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    ## Treat all warnings as errors.
    warn <- getOption(x = "warn")
    options("warn" = 2L)
    df <- utils::installed.packages(lib.loc = lib)
    installedPkgs <- rownames(df)
    removePkgs <- intersect(pkgs, installedPkgs)
    skipPkgs <- setdiff(pkgs, installedPkgs)
    if (isTRUE(length(skipPkgs) > 0L)) {
        message(sprintf("Skipping packages: %s", toString(skipPkgs))) # nocov
    }
    if (isTRUE(length(removePkgs) > 0L)) {
        message(sprintf("Removing packages: %s", toString(removePkgs)))
        utils::remove.packages(pkgs = removePkgs, lib = lib)
    }
    options("warn" = warn)
    invisible(list(
        "pkgs" = removePkgs,
        "lib" = lib
    ))
}
