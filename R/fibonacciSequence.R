#' Fibonacci sequence
#'
#' @export
#' @note Updated 2019-07-26.
#'
#' @param len `integer(1)`.
#'
#' @return `integer`.
#'
#' @examples
#' fibonacciSequence(8L)
fibonacciSequence <- function(len) {
    stopifnot(is.integer(len), identical(length(len), 1L))
    x <- numeric(len)
    x[1L] <- 1L  # nolint
    x[2L] <- 1L  # nolint
    for (i in 3L:len) {
        x[i] <- x[i - 1L] + x[i - 2L]
    }
    x
}
