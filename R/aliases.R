## nocov start



#' Aliases
#'
#' Mnemonic functions and shortcut aliases, to reduce common keystrokes.
#'
#' @name aliases
#' @note Updated 2021-08-23.
#'
#' @param ... Passthrough arguments.
#'
#' @return Varies, depending on the function.
#'
#' @examples
#' ## > d()
NULL



#' @describeIn aliases
#' Alias for `setwd()`.
#' @export
cd <- function(...) {
    setwd(...) # nolint
}



#' @describeIn aliases
#' Alias for `cat("\f")`.
#' @export
clear <- function() {
    cat("\f")
}



#' @describeIn aliases
#' Alias for `document()`.
#' @export
d <- function(...) {
    document(...)
}



#' @describeIn aliases
#' Alias for `load_all()`.
#' @export
la <- function(...) {
    load_all(...)
}



## nocov end
