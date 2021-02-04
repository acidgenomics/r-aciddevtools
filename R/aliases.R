#' Aliases
#'
#' Shortcut aliases to reduce common keystrokes.
#'
#' @name aliases
#' @note Updated 2021-02-02.
#'
#' @param ... Passthrough arguments.
#'
#' @return Varies, depending on the function.
#'
#' @examples
#' ## > d()
NULL



#' @rdname aliases
#' @export
d <- function(...) {
    document(...)
}



#' @rdname aliases
#' @export
la <- function(...) {
    load_all(...)
}
