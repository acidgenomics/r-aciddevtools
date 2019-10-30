#' Copy to clipboard
#'
#' @export
#' @note Only works on macOS.
#' @note Updated 2019-10-30.
#'
#' @inheritParams params
#'
#' @examples
#' if (identical(Sys.info()[[1L]], "Darwin")) {
#'     x <- "hello world"
#' pbcopy(x)
#' }
pbcopy <- function(x) {
    stopifnot(
        identical(Sys.info()[[1L]], "Darwin"),
        requireNamespace("utils", quietly = TRUE)
    )
    utils::capture.output(x, file = pipe("pbcopy"))
}
