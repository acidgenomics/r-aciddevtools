#' Open Finder to the current directory
#' @note macOS only.
#' @export
#' @inheritParams params
#' @return Opens window. No return.

## Updated 2019-07-26.
finder <- function(path = ".") {
    stopifnot(Sys.info()[[1L]] == "Darwin")
    stopifnot(is.character(path) && length(character) == 1L)
    system(paste("open", path))
}
