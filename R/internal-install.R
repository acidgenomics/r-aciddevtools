## nocov start



#' Install packages, if necessary
#'
#' @note Updated 2021-08-22.
#' @noRd
#'
#' @param pkgs `character`.
#'   R package names to install.
#' @param lib `character(1)`.
#'   R package library path.
#'   See `.libPaths()` for details.
#'
#' @return Invisible `logical(1)`
#'
#' @examples
#' ## > .installIfNecessary("BiocManager")
.installIfNecessary <- function(
    pkgs,
    lib = .libPaths()[[1L]]
) {
    warn <- getOption("warn")
    options("warn" = 2L)
    invisible(lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!requireNamespace(pkg, quietly = TRUE)) {
                utils::install.packages(
                    pkgs = pkg,
                    repos = .cran,
                    lib = lib
                )
            }
        }
    ))
    options("warn" = warn)
    invisible(TRUE)
}



## nocov end
