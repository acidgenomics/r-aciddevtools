#' Script path
#'
#' @export
#' @note Only currently works inside RStudio.
#' @note Updated 2019-10-19.
#'
#' @return `character(1)`.
#'   Normalized path to current script.
#'
scriptPath <- function() {
    assert(
        isTRUE(nzchar(Sys.getenv("RSTUDIO_USER_IDENTITY"))),
        requireNamespace("rstudioapi", quietly = TRUE)
    )
    x <- rstudioapi::getSourceEditorContext()[["path"]]
    x <- normalizePath(x)
    x
}
