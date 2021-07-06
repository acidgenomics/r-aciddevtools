#' Wrapper for BiocManager validity checks
#'
#' @note Updated 2020-12-03.
#' @noRd
#'
#' @return Passthrough to `BiocManager::valid`.
.valid <- function() {
    tryCatch(
        expr = BiocManager::valid(),
        warning = function(w) {
            result <- utils::capture.output(suppressWarnings({
                BiocManager::valid()
            }))
            cat(result, sep = "\n")
            stop(w)
        }
    )
}
