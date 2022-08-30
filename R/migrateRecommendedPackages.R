#' Migrate recommended packages
#'
#' @export
#' @note Updated 2022-08-30.
#'
#' @details
#' Currently includes these packages:
#'
#' - KernSmooth
#' - MASS
#' - Matrix
#' - boot
#' - class
#' - cluster
#' - codetools
#' - foreign
#' - lattice
#' - mgcv
#' - nlme
#' - nnet
#' - rpart
#' - spatial
#' - survival
#'
#' @seealso
#' - `.libPaths()`
#' - `.Library`, `.Library.site`.
#' - `.installed.packages()`, `install.packages()`.
migrateRecommendedPackages <-
    function() {
        pkgs <- character()
        x <- installed.packages(lib.loc = .Library)
        lgl <- x[, "Priority"] != "base"
        if (any(lgl)) {
            idx <- which(lgl)
            pkgs <- names(idx)
            install.packages(pkgs, lib = .Library.site)
            remove.packages(pkgs, lib = .Library)
        }
        invisible(pkgs)
    }
