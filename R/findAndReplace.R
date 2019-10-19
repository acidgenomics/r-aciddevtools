#' Find and replace across a directory.
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @inheritParams params
#' @param pattern `character(1)`.
#'   Pattern string.
#' @param replacement `character(1)`.
#'   Replacement string.
#' @param recursive  `logical(1)`.
#'   Search recursively?
#'
#' @return Invisibly return file paths.
findAndReplace <- function(
    pattern,
    replacement,
    dir = ".",
    recursive = FALSE
) {
    stopifnot(
        requireNamespace("parallel", quietly = TRUE),
        requireNamespace("readr", quietly = TRUE),
    )
    files <- sort(list.files(
        path = dir,
        pattern = "(r|R)$",
        full.names = TRUE,
        recursive = recursive
    ))
    invisible(parallel::mclapply(
        X = files,
        FUN = function(file) {
            x <- readr::read_lines(file)
            x <- gsub(
                pattern = pattern,
                replacement = replacement,
                x = x
            )
            readr::write_lines(x, path = file)
        }
    ))
}
