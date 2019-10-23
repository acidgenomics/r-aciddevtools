#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2019-10-23.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
finder <- function(path = ".") {
    stopifnot(
        Sys.info()[[1L]] == "Darwin",
        is.character(path) && identical(length(character), 1L)
    )
    system2(command = "open", args = path)
}
