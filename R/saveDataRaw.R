#' Save Raw Data
#'
#' Wrapper for [saveData()] that enables quick saving of objects to the
#' `data-raw/` directory.
#' 
#' @params ... Dot objects.
#'
#' @seealso [devtools::use_data_raw()].
#'
#' @export
saveDataRaw <- function(...) {
        saveData(..., dir = "data-raw")
    })
