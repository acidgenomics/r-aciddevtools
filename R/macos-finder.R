#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2020-10-06.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
finder <- function(path = ".") {
    stopifnot(
        requireNamespace("AcidBase", quietly = TRUE),
        requireNamespace("goalie", quietly = TRUE),
        goalie::isMacOS(),
        goalie::isString(path)
    )
    AcidBase::shell(command = "open", args = path)
}
