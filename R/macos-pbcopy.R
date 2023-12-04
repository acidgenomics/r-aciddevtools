#' Copy to clipboard
#'
#' @export
#' @note Only works on macOS.
#' @note Updated 2022-10-20.
#'
#' @inheritParams params
#'
#' @examples
#' if (goalie::isMacos()) {
#'     x <- "hello world"
#'     pbcopy(x)
#' }
pbcopy <- function(x) {
    stopifnot(
        .requireNamespaces("utils"),
        .isMacos()
    )
    utils::capture.output(x, file = pipe("pbcopy"))
}
