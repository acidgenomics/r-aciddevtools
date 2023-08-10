#' Friendly human readable object size
#'
#' @export
#' @note Updated 2023-08-09.
#'
#' @inheritParams params
#'
#' @return `character(1)`.
#' Object size.
#'
#' @examples
#' x <- c("aaa", "bbb")
#' print(size(x))
size <- function(x) {
    stopifnot(.requireNamespaces("utils"))
    x <- utils::object.size(x)
    x <- format(x, units = "auto")
    x
}
