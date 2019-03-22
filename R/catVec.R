#' Print (cat) a vector
#' @export
#' @inheritParams params
#' @return Console output.
catVec <- function(x) {
    x <- paste0("\"", x, "\"")
    x <- paste(x, collapse = ",\n")
    cat(x)
}
