## nocov start



#' CRAN mirror
#'
#' @note Updated 2020-11-11.
#' @noRd
.cran <- "https://cloud.r-project.org"



#' Homebrew opt prefix
#'
#' @note Updated 2021-04-30.
#' @noRd
.homebrewOpt <- function() {
    x <- .homebrewPrefix()
    if (isFALSE(dir.exists(x))) return("")
    x <- file.path(x, "opt")
    stopifnot(dir.exists(x))
    x
}



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
    if (isFALSE(dir.exists(x))) return("")
    x
}



#' Koopa opt prefix.
#'
#' @note Updated 2021-04-30.
#' @noRd
.koopaOpt <- function() {
    x <- .koopaPrefix()
    if (isFALSE(dir.exists(x))) return("")
    x <- file.path(x, "opt")
    stopifnot(dir.exists(x))
    x
}



#' Koopa prefix.
#'
#' @note Updated 2021-04-30.
#' @noRd
.koopaPrefix <- function() {
    x <- Sys.getenv("KOOPA_PREFIX")
    if (isFALSE(dir.exists(x))) return("")
    x
}



## nocov end
