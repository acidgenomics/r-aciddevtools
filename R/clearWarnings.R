#' Clear (reset) all warnings
#'
#' Reassigns `last.warning` value in base environment.
#'
#' @export
#' @note Updated 2019-10-19.
#'
#' @return No value.
#'
#' @examples
#' clearWarnings()
clearWarnings <- function() {
    assign(x = "last.warning", value = NULL, envir = baseenv())
}
