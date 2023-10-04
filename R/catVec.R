#' Print (cat) a vector to console
#'
#' @export
#' @note Updated 2023-09-07.
#'
#' @inheritParams params
#'
#' @return Console output.
#'
#' @examples
#' ## Unnamed vector.
#' x <- c("aaa", "bbb", "ccc")
#' catVec(x)
#'
#' ## Named vector.
#' x <- c("aaa" = "AAA", "bbb" = "BBB", "ccc" = "CCC")
#' catVec(x)
catVec <- function(x) {
    stopifnot(is.vector(x))
    if (is.null(names(x))) {
        x <- vapply(X = x, FUN = deparse, FUN.VALUE = character(1L))
    } else {
        x <- unlist(Map(
            name = names(x),
            value = unname(x),
            f = function(name, value) {
                paste0(deparse(name), " = ", deparse(value))
            }
        ))
    }
    x <- paste(x, collapse = ",\n")
    cat(x)
}
