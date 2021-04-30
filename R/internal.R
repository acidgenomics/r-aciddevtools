#' CRAN mirror
#'
#' @note Updated 2020-11-11.
#' @noRd
.cran <- "https://cloud.r-project.org"



## FIXME This is erroring on Linux if Homebrew isn't installed...

#' Homebrew opt prefix
#'
#' @note Updated 2021-04-30.
#' @noRd
.homebrewOpt <- function() {
    x <- .homebrewPrefix()
    if (isFALSE(dir.exists(x))) return(NULL)
    x <- file.path(x, "opt")
    stopifnot(dir.exists(x))
    x
}



## FIXME This is erroring on Linux if Homebrew isn't installed...

#' Homebrew prefix
#'
#' @note Updated 2021-04-30.
#' @noRd
.homebrewPrefix <- function() {
    x <- Sys.getenv("HOMEBREW_PREFIX")
    if (isTRUE(nchar(x) > 0L)) {
        stopifnot(dir.exists(x))
        return(x)
    }
    if (.isMacOS()) {
        if (isTRUE(dir.exists(file.path("", "opt", "homebrew")))) {
            x <- file.path("", "opt", "homebrew")
        } else {
            x <- file.path("", "usr", "local")
        }
    } else if (.isLinux()) {
        x <- file.path("", "home", "linuxbrew", ".linuxbrew")
    }
    if (isFALSE(dir.exists(x))) return(NULL)
    x
}



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



## FIXME Does this work on Linux if koopa isn't installed?

#' Koopa opt prefix.
#'
#' @note Updated 2021-04-30.
#' @noRd
.koopaOpt <- function() {
    x <- .koopaPrefix()
    if (isFALSE(dir.exists(x))) return(NULL)
    x <- file.path(x, "opt")
    stopifnot(dir.exists(x))
    x
}



## FIXME Does this work on Linux if koopa isn't installed?

#' Koopa prefix.
#'
#' @note Updated 2021-04-30.
#' @noRd
.koopaPrefix <- function() {
    x <- Sys.getenv("KOOPA_PREFIX")
    if (isFALSE(dir.exists(x))) return(NULL)
    x
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
