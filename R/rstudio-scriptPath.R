#' Script path
#'
#' @export
#' @note Only currently works inside RStudio.
#' @note Updated 2020-04-12.
#'
#' @return `character(1)`.
#'   Normalized path to current script.
#'
scriptPath <- function() {
    assert(isRStudio())
    requireNamespaces("rstudioapi")
    x <- rstudioapi::getSourceEditorContext()[["path"]]
    x <- normalizePath(x)
    x
}
