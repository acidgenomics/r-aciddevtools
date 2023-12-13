#' Inspect a single (nested) row of a data frame
#'
#' @export
#' @note Updated 2023-12-13.
#'
#' @param object Object.
#' Data structure that can be coerced to `data.frame`.
#'
#' @param i `integer(1)` or `character(1)`.
#' Row position or name.
#'
#' @return Console output.
#' Invisibly returns dropped data structure.
#'
#' @examples
#' object <- datasets::mtcars
#' inspectRow(object, i = 1L)
inspectRow <- function(object, i) {
    stopifnot(
        is.integer(i) || is.character(i),
        length(i) == 1L
    )
    out <- as.data.frame(object)[i, , drop = TRUE]
    print(out)
    invisible(out)
}
