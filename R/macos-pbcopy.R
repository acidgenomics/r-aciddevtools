## nocov start



#' Copy to clipboard
#'
#' @export
#' @note Only works on macOS.
#' @note Updated 2022-10-20.
#'
#' @inheritParams params
#'
#' @examples
#' if (goalie::isMacOS()) {
#'     x <- "hello world"
#'     pbcopy(x)
#' }
pbcopy <- function(x) {
    stopifnot(
        .requireNamespaces("utils"),
        .isMacOS()
    )
    utils::capture.output(x, file = pipe("pbcopy"))
}



## nocov end
