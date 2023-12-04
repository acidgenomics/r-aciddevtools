#' View object
#'
#' This variant performs internal coercion to data.frame, so we can easily
#' view S4 DataFrame and GenomicRanges objects.
#'
#' @export
#' @note Updated 2023-10-06.
#'
#' @inheritParams params
#'
#' @return Invisible `NULL`.
#' This function puts up a window and returns immediately.
#' In RStudio, this will open a tabbed window.
#'
#' @seealso
#' - https://support.bioconductor.org/p/9137534/
#'
#' @examples
#' ## > view2(mtcars)
view2 <- function(object) {
    ## Coerce S4 object, if applicable.
    if (.isAny(object, c("DataFrame", "GenomicRanges"))) {
        ## Coercion with `as.data.frame` can change column names.
        ## Alternative approach:
        ## > object <- as(object, "data.frame")
        object <- as.data.frame(object, optional = TRUE)
    }
    if (!.isRstudio()) {
        stopifnot(.requireNamespaces("utils"))
        View <- utils::View # nolint
    }
    View(object)
}
