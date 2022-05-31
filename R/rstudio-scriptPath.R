## nocov start



#' Script path
#'
#' @export
#' @note Only currently works inside RStudio.
#' @note Updated 2022-05-31.
#'
#' @return `character(1)`.
#' Normalized path to current script.
#'
scriptPath <- function() {
    stopifnot(
        requireNamespace("goalie", quietly = TRUE),
        goalie::isRStudio(),
        requireNamespace("rstudioapi", quietly = TRUE)
    )
    x <- rstudioapi::getSourceEditorContext()[["path"]]
    x <- .realpath(x)
    x
}



## nocov end
