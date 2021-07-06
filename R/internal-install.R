#' Install packages, if necessary
#'
#' @note Updated 2020-11-11.
#' @noRd
#'
#' @return Invisible `logical(1)`.
.installIfNecessary <- function(pkgs) {
    warn <- getOption("warn")
    options("warn" = 2L)
    invisible(lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!requireNamespace(pkg, quietly = TRUE)) {
                utils::install.packages(pkgs = pkg, repos = .cran)
            }
        }
    ))
    options("warn" = warn)
    invisible(TRUE)
}
