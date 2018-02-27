#' Read CSV Files Inside `data-raw/` Directory
#'
#' This function automatically loads raw CSVs using the readr package and
#' saves the data as R binary data into the `data/` directory.
#'
#' @importFrom fs dir_create dir_ls path
#' @importFrom readr read_csv
#' @importFrom tools file_path_sans_ext
#'
#' @return No value.
#' @export
readDataRaw <- function() {
    csv <- dir_ls("data-raw", pattern = "*.csv")
    lapply(seq_along(csv), function(a) {
        name <- basename(csv[a]) %>%
            file_path_sans_ext()
        df <- read_csv(csv[a])
        dir_create("data")
        assign(name, df)
        save(list = name, file = path("data", paste0(name, ".rda")))
    }) %>%
        invisible()
}
