#' Lint a directory
#'
#' @export
#' @note Updated 2019-08-05.
#'
#' @param path `character(1)`.
#'   Directory path.
#' @param recursive `logical(1)`.
#'   Search recursively.
#'
#' @return Lintr checks.
lint_dir <-  # nolint
    function(
        path = ".",
        recursive = FALSE
    ) {
        requireNamespace("lintr")
        files <- sort(list.files(
            path = path,
            pattern = "*.R",
            full.names = TRUE,
            recursive = recursive
        ))
        invisible(lapply(
            X = files,
            FUN = function(file) {
                message(file)
                lintr::lint(file)
            }
        ))
    }
