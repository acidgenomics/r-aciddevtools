#' CRAN mirror
#'
#' @note Updated 2020-11-11.
#' @noRd
.cran <- "https://cloud.r-project.org"



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



#' Is a package installed?
#'
#' @note Updated 2020-08-11.
#' @noRd
#'
#' @return `logical(1)`.
.isInstalled <- function(pkgs) {
    basename(pkgs) %in% rownames(utils::installed.packages())
}



#' Is the platform Linux?
#'
#' @note Updated 2021-04-30.
#' @noRd
#'
#' @return `logical(1)`.
#'
#' @seealso `goalie::isLinux`.
.isLinux <- function() {
    isTRUE(grepl(pattern = "linux", x = R.Version()[["os"]]))
}



#' Is the platform macOS?
#'
#' @note Updated 2021-04-30.
#' @noRd
#'
#' @return `logical(1)`.
#'
#' @seealso `goalie::isMacOS`.
.isMacOS <- function() {
    isTRUE(grepl(pattern = "darwin", x = R.Version()[["os"]]))
}




#' Wrapper for BiocManager validity checks
#'
#' @note Updated 2020-12-03.
#' @noRd
#'
#' @return Passthrough to `BiocManager::valid`.
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
