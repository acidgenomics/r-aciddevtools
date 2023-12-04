#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2023-10-24.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
#'
#' @examples
#' ## > finder(path = "~")
finder <- function(path = getwd()) {
    stopifnot(
        .isMacos(),
        .isString(path)
    )
    path <- .realpath(path)
    .shell(command = "open", args = path)
}
