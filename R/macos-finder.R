#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2021-08-22.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
#'
#' @examples
#' ## > finder(path = "~")
finder <- function(path = getwd()) {
    stopifnot(
        requireNamespace("AcidBase", quietly = TRUE),
        requireNamespace("goalie", quietly = TRUE),
        goalie::isMacOS(),
        goalie::isString(path)
    )
    path <- normalizePath(path, mustWork = TRUE)
    AcidBase::shell(command = "open", args = path)
}
