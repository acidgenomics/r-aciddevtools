#' Check Package
#'
#' @importFrom BiocCheck BiocCheck
#'
#' @inherit devtools::check
#'
#' @return No return.
#' @export
check <- function(...) {
    devtools::check(...)
    BiocCheck(getwd())
}
