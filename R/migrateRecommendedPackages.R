#' Migrate recommended packages
#'
#' @export
#' @note Updated 2022-10-20.
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
#'
#' @examples
#' ## > migrateRecommendedPackages()
migrateRecommendedPackages <-
    function() {
        stopifnot(requireNamespace("utils", quietly = TRUE))
        pkgs <- character()
        x <- utils::installed.packages(lib.loc = .Library)
        lgl <- x[, "Priority"] != "base"
        if (any(lgl)) {
            idx <- which(lgl)
            pkgs <- names(idx)
            message(sprintf(
                "Migrating %d %s from '%s' to '%s': %s.",
                length(pkgs),
                ngettext(
                    n = length(pkgs),
                    msg1 = "package",
                    msg2 = "packages"
                ),
                .Library,
                .Library.site,
                toString(pkgs)
            ))
            utils::install.packages(pkgs, lib = .Library.site)
            utils::remove.packages(pkgs, lib = .Library)
        }
        allPkgs <- unname(utils::installed.packages()[, "Package"])
        if (.hasDuplicates(allPkgs)) {
            dupes <- allPkgs[duplicated(allPkgs)]
            stop(sprintf(
                "Duplicate %s detected: %s.",
                ngettext(
                    n = length(dupes),
                    msg1 = "package",
                    msg2 = "packages"
                ),
                toString(dupes)
            ))
        }
        invisible(pkgs)
    }
