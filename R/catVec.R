#' Concatenate and Print a Vector
#'
#' Print vector to console quoted, with comma delims
#'
#' @param x Object.
#'
#' @return Console output.
#' @export
#'
#' @examples
#' c("hello", "world") %>% catVec()
catVec <- function(x) {
    x <- paste0("\"", x, "\"")
    x <- paste(x, collapse = ",\n")
    cat(x)
}
