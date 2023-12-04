#' CRAN mirror
#'
#' @note Updated 2020-11-11.
#' @noRd
.cran <- "https://cloud.r-project.org"



#' Homebrew opt prefix
#'
#' @note Updated 2021-09-22.
#' @noRd
.homebrewOpt <- function() {
    x <- .homebrewPrefix()
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x <- file.path(x, "opt")
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x
}



#' Homebrew prefix
#'
#' @note Updated 2021-10-06.
#' @noRd
.homebrewPrefix <- function() {
    x <- Sys.getenv("HOMEBREW_PREFIX")
    if (isTRUE(nchar(x) > 0L)) {
        if (isFALSE(dir.exists(x))) {
            return("")
        } else {
            return(x)
        }
    }
    if (.isMacos()) {
        if (isTRUE(dir.exists(file.path("", "opt", "homebrew")))) {
            x <- file.path("", "opt", "homebrew")
        } else {
            x <- file.path("", "usr", "local")
        }
    } else if (.isLinux()) {
        x <- file.path("", "home", "linuxbrew", ".linuxbrew")
    }
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x
}



#' Koopa opt prefix.
#'
#' @note Updated 2021-09-22.
#' @noRd
.koopaOpt <- function() {
    x <- .koopaPrefix()
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x <- file.path(x, "opt")
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x
}



#' Koopa prefix.
#'
#' @note Updated 2021-04-30.
#' @noRd
.koopaPrefix <- function() {
    x <- Sys.getenv("KOOPA_PREFIX")
    if (isFALSE(dir.exists(x))) {
        return("")
    }
    x
}



#' Normalize file path
#'
#' @note Updated 2022-05-31.
#' @noRd
.realpath <- function(path) {
    normalizePath(
        path = path,
        winslash = .Platform[["file.sep"]],
        mustWork = TRUE
    )
}
