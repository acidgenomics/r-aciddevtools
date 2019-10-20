#' Change directory
#'
#' Alias for [setwd()] function.
#'
#' @export
#' @note Updated 2019-10-19.
#'
#' @inheritParams params
#'
#' @examples
#' cd("~")
cd <- function(dir) {
    setwd(dir)
}
