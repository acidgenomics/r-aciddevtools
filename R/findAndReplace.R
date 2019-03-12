# Find and replace across a directory.
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

