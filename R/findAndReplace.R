## FIXME Consider moving this to koopa package.
## FIXME Can we switch to base read and writeLines here?
## FIXME Move this to koopa package.



#' Find and replace in files across a directory
#'
#' @export
#' @note Updated 2021-08-23.
#' @note Requires `BiocParallel` package to be installed.
#'
#' @inheritParams params
#' @param pattern `character(1)`.
#'   Pattern string, supporting regular expressions.
#' @param replacement `character(1)`.
#'   Replacement string.
#' @param filePattern `character(1)`.
#'   File pattern matching string.
#'   Defaults to matching against R files.
#' @param recursive  `logical(1)`.
#'   Search recursively?
#'
#' @return Invisibly return file paths.
#'
#' @examples
#' unlink("testdata", recursive = TRUE)
#' dir.create(file.path("testdata", "subdir"), recursive = TRUE)
#' writeLines(
#'     text = "print(\"foo\")",
#'     con = file.path("testdata", "aaa.R"),
#' )
#' writeLines(
#'     text = "print(\"foo\")",
#'     con = file.path("testdata", "subdir", "bbb.R"),
#' )
#' out <- findAndReplace(
#'     pattern = "foo",
#'     replacement = "bar",
#'     dir = "testdata",
#'     recursive = TRUE
#' )
#' print(out)
#' print(readLines(out[[1L]]))
#' unlink("testdata", recursive = TRUE)
findAndReplace <- function(
    pattern,
    replacement,
    filePattern = "\\.(r|R)$",
    dir = getwd(),
    recursive = FALSE
) {
    stopifnot(requireNamespace("BiocParallel", quietly = TRUE))
    dir <- normalizePath(dir, mustWork = TRUE)
    files <- sort(list.files(
        path = dir,
        pattern = filePattern,
        full.names = TRUE,
        recursive = recursive
    ))
    stopifnot(length(files) > 0L)
    out <- BiocParallel::bplapply(
        X = files,
        FUN = function(file) {
            x <- readLines(con = file)
            x <- gsub(
                pattern = pattern,
                replacement = replacement,
                x = x
            )
            writeLines(text = x, con = file)
            file
        }
    )
    out <- unlist(out, recursive = FALSE)
    invisible(out)
}
