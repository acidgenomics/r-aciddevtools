#' Lint a directory
#'
#' @export
#' @note Updated 2019-08-05.
#'
#' @param dir `character(1)`.
#'   Directory path.
#' @param recursive `logical(1)`.
#'   Search recursively.
lint_dir <- function(dir, recursive = FALSE) {
    requireNamespace("lintr")
    files <- list.files(
        path = dir,
        pattern = "*.R",
        recursive = recursive
    )
    lapply(
        X = files,
        FUN = function(file) {
            lintr::lint(file)
        }
    )
}
