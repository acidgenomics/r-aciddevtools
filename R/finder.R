#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2019-08-13.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
finder <- function(path = ".") {
    stopifnot(
        Sys.info()[[1L]] == "Darwin",
        is.character(path) && identical(length(character), 1L)
    )
    system(paste("open", path))
}
