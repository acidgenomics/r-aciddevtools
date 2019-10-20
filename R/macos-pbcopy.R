#' Copy to clipboard
#'
#' @export
#' @note Only works on macOS.
#' @note Updated 2019-10-19.
#'
#' @inheritParams params
#'
#' @examples
#' x <- "hello world"
#' pbcopy(x)
pbcopy <- function(x) {
    stopifnot(
        identical(Sys.info()[[1L]], "Darwin"),
        requireNamespace("utils", quietly = TRUE)
    )
    utils::capture.output(x, file = pipe("pbcopy"))
}
