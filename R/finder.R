#' Open Finder to the current directory.
#'
#' @note macOS only.
#'
#' @export
#' @param path File path.
finder <- function(path = ".") {
    stopifnot(Sys.info()[[1L]] == "Darwin")
    stopifnot(is.character(path) && length(character) == 1L)
    system(paste("open", path))
}
