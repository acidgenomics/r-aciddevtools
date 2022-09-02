#' Migrate recommended packages
#'
#' @export
#' @note Updated 2022-09-02.
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
        ## FIXME We need to conditionally load utils here.
        x <- installed.packages(lib.loc = .Library)
        lgl <- x[, "Priority"] != "base"
        if (any(lgl)) {
            idx <- which(lgl)
            pkgs <- names(idx)
            ## FIXME We need to conditionally load utils here.
            install.packages(pkgs, lib = .Library.site)
            ## FIXME We need to conditionally load utils here.
            remove.packages(pkgs, lib = .Library)
        }
        ## FIXME We need to conditionally load utils here.
        stopifnot(anyDuplicated(rownames(installed.packages())) > 0L)
        invisible(pkgs)
    }
