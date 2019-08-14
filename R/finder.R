#' Open Finder to the current directory
#' @note macOS only.
#' @note Updated 2019-08-13.
#' @export
#' @inheritParams params
#' @return Opens window. No return.
finder <- function(path = ".") {
    assert(
        Sys.info()[[1L]] == "Darwin",
        is.character(path) && length(character) == 1L
    )
    system(paste("open", path))
}
