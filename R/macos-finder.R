## nocov start



#' Open Finder to the current directory
#'
#' @export
#' @note macOS only.
#' @note Updated 2022-10-20.
#'
#' @inheritParams params
#'
#' @return Opens window. No return.
#'
#' @examples
#' ## > finder(path = "~")
finder <- function(path = getwd()) {
    stopifnot(
        .requireNamespaces("AcidBase"),
        .isMacOS(),
        .isString(path)
    )
    path <- .realpath(path)
    AcidBase::shell(command = "open", args = path)
}



## nocov end
