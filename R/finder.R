#' Open Working Directory in Finder
#'
#' @return No return.
#' @export
#'
#' @examples
#' finder()
finder <- function() {
    if (Sys.info()[1] != "Darwin") {
        stop("'finder()' only supported on macOS")
    }
    system(paste("open", getwd()))
}
