#' Open Working Directory in Finder
#'
#' @return No return.
#' @export
#'
#' @examples
#' \dontrun{
#' finder()
#' }
finder <- function() {
    if (Sys.info()[[1L]] == "Darwin") {
        system(paste("open", getwd()))
    } else {
        stop("`finder()` is only supported on macOS")
    }
}
