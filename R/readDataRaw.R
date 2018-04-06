#' Read CSV Files Inside `data-raw/` Directory
#'
#' This function automatically loads raw CSVs using the readr package and
#' saves the data as R binary data into the `data/` directory.
#'
#' @return No value.
#' @export
readDataRaw <- function(
    dir = "data-raw",
    ext = c("csv", "mtx", "tsv")
) {
    files <- list.files(
        path = dir,
        pattern = paste0("\\.(", paste(ext, collapse = "|"), ")$")
    )
    invisible(lapply(
        X = files,
        FUN = function(file) {
            name <- file_path_sans_ext(basename(file))
            df <- readFileByExtension(file)
            dir.create("data", showWarnings = FALSE)
            assign(name, df)
            save(list = name, file = file.path("data", paste0(name, ".rda")))
        }
    ))
}
