## nocov start



#' Script path
#'
#' @export
#' @note Only currently works inside RStudio.
#' @note Updated 2022-10-20.
#'
#' @return `character(1)`.
#' Normalized path to current script.
#'
scriptPath <- function() {
    stopifnot(
        .requireNamespaces("rstudioapi"),
        .isRStudio()
    )
    x <- rstudioapi::getSourceEditorContext()[["path"]]
    stopifnot(.isAFile(x))
    x <- .realpath(x)
    x
}



## nocov end
