#' Find and replace across a directory.
#'
#' @export
#'
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
    files <- list.files(
        path = dir,
        pattern = "(r|R)$",
        full.names = TRUE,
        recursive = recursive
    )
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

