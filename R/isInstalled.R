#' Is the desired package installed?
#'
#' @export
#' @note Update 2019-10-23.
#'
#' @param pkg `character`.
#'   Package names.
#'
#' @return `logical(1)`.
#'
#' @examples
#' isInstalled(pkg = c("bb8", "XXX"))
isInstalled <- function(pkg) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    pkg %in% rownames(utils::installed.packages())
}
