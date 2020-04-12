#' Fibonacci sequence
#'
#' @export
#' @note Updated 2020-04-09.
#'
#' @param len `integer(1)`.
#'
#' @return `integer`.
#'
#' @examples
#' fibonacciSequence(8L)
fibonacciSequence <- function(len) {
    assert(isInt(len))
    ## Set the lengh of the numeric vector.
    x <- numeric(len)
    x[1L] <- 1L  # nolint
    if (identical(length(x), 1L)) return(x)
    x[2L] <- 1L  # nolint
    if (identical(length(x), 2L)) return(x)
    for (i in 3L:len) {
        x[i] <- x[i - 1L] + x[i - 2L]
    }
    x
}
