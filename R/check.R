#' Check Package
#'
#' @inherit devtools::check
#'
#' @return No return.
#' @export
check <- function(...) {
    check(...)
    BiocCheck(".")
}
