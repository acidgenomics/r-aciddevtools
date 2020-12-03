#' CRAN mirror
#'
#' @note Updated 2020-11-11.
#' @noRd
.cran <- "https://cloud.r-project.org"



#' Install packages, if necessary
#'
#' @note Updated 2020-11-11.
#' @noRd
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



#' Is a package installed?
#'
#' @note Updated 2020-08-11.
#' @noRd
.isInstalled <- function(pkgs) {
    basename(pkgs) %in% rownames(utils::installed.packages())
}



#' Wrapper for BiocManager validity checks
#'
#' @note Updated 2020-12-03.
#' @noRd
.valid <- function() {
    tryCatch(
        expr = BiocManager::valid(),
        warning = function(w) {
            result <- utils::capture.output(suppressWarnings({
                BiocManager::valid()
            }))
            cat(result, sep = "\n")
            stop(w)
        }
    )
}
