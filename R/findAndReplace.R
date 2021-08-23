## FIXME Consider moving this to koopa package.
## FIXME Can we switch to base read and writeLines here?
## FIXME Move this to koopa package.



#' Find and replace in files across a directory
#'
#' @export
#' @note Updated 2021-08-23.
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
#' print("FIXME This needs a working example.")
findAndReplace <- function(
    pattern,
    replacement,
    filePattern = "\\.(r|R)$",
    dir = getwd(),
    recursive = FALSE
) {
    dir <- normalizePath(dir, mustWork = TRUE)
    files <- sort(list.files(
        path = dir,
        pattern = filePattern,
        full.names = TRUE,
        recursive = recursive
    ))
    ## FIXME Return with error if no files match.
    ## Run the `lapply()` call in parallel, if possible.
    if (.isInstalled("BiocParallel")) {
        stopifnot(requireNamespace("BiocParallel", quietly = TRUE))
        lapply <- BiocParallel::bplapply
    } else if (.isInstalled("parallel")) {
        stopifnot(requireNamespace("parallel", quietly = TRUE))
        lapply <- parallel::mclapply
    }
    out <- lapply(
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
    invisible(out)
}
