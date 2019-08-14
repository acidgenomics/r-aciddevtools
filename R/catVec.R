#' Print (cat) a vector
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @inheritParams params
#'
#' @return Console output.
catVec <- function(x) {
    x <- paste0("\"", x, "\"")
    x <- paste(x, collapse = ",\n")
    cat(x)
}
