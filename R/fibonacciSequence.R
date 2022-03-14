#' Fibonacci sequence
#'
#' @export
#' @note Updated 2021-08-23.
#'
#' @param len `integer(1)`.
#'
#' @return `integer`.
#'
#' @examples
#' fibonacciSequence(8L)
fibonacciSequence <- function(len) {
    stopifnot(is.integer(len) && identical(length(len), 1L))
    x <- integer(len)
    x[1L] <- 1L # nolint
    if (identical(length(x), 1L)) {
        return(x)
    }
    x[2L] <- 1L # nolint
    if (identical(length(x), 2L)) {
        return(x)
    }
    for (i in 3L:len) {
        x[i] <- x[i - 1L] + x[i - 2L]
    }
    x
}
