#' Migrate recommended packages
#'
#' @export
#' @note Updated 2022-09-06.
#'
#' @details
#' Currently includes these packages: KernSmooth, MASS, Matrix, boot, class,
#' cluster, codetools, foreign, lattice, mgcv, nlme, nnet, rpart, spatial,
#' survival.
#'
#' @seealso
#' - `.libPaths()`
#' - `.Library`, `.Library.site`.
#' - `.installed.packages()`, `install.packages()`.
migrateRecommendedPackages <-
    function() {
        stopifnot(requireNamespace("utils", quietly = TRUE))
        pkgs <- character()
        x <- utils::installed.packages(lib.loc = .Library)
        lgl <- x[, "Priority"] != "base"
        if (any(lgl)) {
            idx <- which(lgl)
            pkgs <- names(idx)
            utils::install.packages(pkgs, lib = .Library.site)
            utils::remove.packages(pkgs, lib = .Library)
        }
        stopifnot(anyDuplicated(rownames(utils::installed.packages())) > 0L)
        invisible(pkgs)
    }
