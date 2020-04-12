#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2020-04-12.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
finder <- function(path = ".") {
    stopifnot(
        requireNamespace("acidbase", quietly = TRUE),
        requireNamespace("goalie", quietly = TRUE),
        goalie::isMacOS(),
        goalie::isString(path)
    )
    acidbase::shell(command = "open", args = path)
}
