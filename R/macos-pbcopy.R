## nocov start



#' Copy to clipboard
#'
#' @export
#' @note Only works on macOS.
#' @note Updated 2020-04-12.
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
        requireNamespace("goalie", quietly = TRUE),
        requireNamespace("utils", quietly = TRUE),
        goalie::isMacOS()
    )
    utils::capture.output(x, file = pipe("pbcopy"))
}



## nocov end
