#' @inherit devtools::check
#' @export
check <- function(...) {
    devtools::check(...)
    BiocCheck(getwd())
}
