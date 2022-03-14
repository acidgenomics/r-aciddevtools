## nocov start



#' Wrapper for BiocManager validity checks
#'
#' @note Updated 2021-08-22.
#' @noRd
#'
#' @return Passthrough to `BiocManager::valid`.
.valid <- function(lib = NULL) {
    tryCatch(
        expr = BiocManager::valid(
            lib.loc = lib
        ),
        warning = function(w) {
            result <- utils::capture.output(suppressWarnings({
                BiocManager::valid(
                    lib.loc = lib
                )
            }))
            cat(result, sep = "\n")
            stop(w)
        }
    )
}



## nocov end
