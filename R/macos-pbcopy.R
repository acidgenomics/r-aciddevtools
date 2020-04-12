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
    assert(isMacOS())
    capture.output(x, file = pipe("pbcopy"))
}
