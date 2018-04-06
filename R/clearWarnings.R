#' Clear Warnings
#'
#' @return No value.
#' @export
clearWarnings <- function() {
    assign("last.warning", NULL, envir = baseenv())
}
