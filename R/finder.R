#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2020-04-07.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
finder <- function(path = ".") {
    assert(
        isMacOS(),
        isString(path)
    )
    system2(command = "open", args = path)
}
