## nocov start



#' View object
#'
#' This variant performs internal coercion to data.frame, so we can easily
#' view S4 DataFrame and GenomicRanges objects.
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @inheritParams params
#'
#' @return Invisible `NULL`.
#' This function puts up a window and returns immediately.
#' In RStudio, this will open a tabbed window.
#'
#' @examples
#' ## > view2(mtcars)
view2 <- function(object) {
    ## Coerce S4 object, if applicable.
    if (.isAny(object, c("DataFrame", "GenomicRanges"))) {
        object <- as.data.frame(object)
    }
    if (!.isRStudio()) {
        stopifnot(.requireNamespaces("utils"))
        View <- utils::View # nolint
    }
    View(object)
}



## nocov end
