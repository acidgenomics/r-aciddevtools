#' Uninstall a package
#'
#' Wrapper for `utils::remove.packages()`.
#'
#' @inheritParams params
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @return Invisible `list`.
#' Metadata containing names of packages that were removed, and the package
#' library path.
#'
#' @examples
#' ## > uninstall("rlang")
uninstall <-
    function(pkgs,
             lib = .libPaths()[[1L]] # nolint
    ) {
        stopifnot(.requireNamespaces("utils"))
        warn <- getOption(x = "warn")
        options("warn" = 2L) # nolint
        installedPkgs <- .packages(all.available = TRUE, lib.loc = lib)
        removePkgs <- intersect(pkgs, installedPkgs)
        skipPkgs <- setdiff(pkgs, installedPkgs)
        if (isTRUE(length(skipPkgs) > 0L)) {
            message(sprintf("Skipping packages: %s", toString(skipPkgs)))
        }
        if (isTRUE(length(removePkgs) > 0L)) {
            message(sprintf("Removing packages: %s", toString(removePkgs)))
            utils::remove.packages(pkgs = removePkgs, lib = lib)
        }
        options("warn" = warn) # nolint
        invisible(list(
            "pkgs" = removePkgs,
            "lib" = lib
        ))
    }
