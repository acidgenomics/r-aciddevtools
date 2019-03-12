#' Print (cat) a vector
#' @export
#' @param x Object.
catVec <- function(x) {
    x <- paste0("\"", x, "\"")
    x <- paste(x, collapse = ",\n")
    cat(x)
}
