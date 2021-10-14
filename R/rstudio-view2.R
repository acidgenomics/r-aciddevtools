## nocov start



#' View object in RStudio viewer
#'
#' This variant performs internal coercion to data.frame, so we can easily
#' view S4 DataFrame and GenomicRanges objects.
#'
#' @export
#' @note Updated 2021-10-14.
#'
#' @inheritParams params
#'
#' @return Invisible `NULL`.
#'   This function puts up a window and returns immediately.
#'   In RStudio, this will open a tabbed window.
#'
#' @examples
#' ## > view2(mtcars)
view2 <- function(object) {
    stopifnot(
        requireNamespace("goalie", quietly = TRUE),
        requireNamespace("utils", quietly = TRUE)
    )
    ## Coerce S4 object, if applicable.
    if (goalie::isAny(object, c("DataFrame", "GenomicRanges"))) {
        object <- as.data.frame(object)
    }
    if (!goalie::isRStudio()) {
        View <- utils::View  # nolint
    }
    View(object)
}



## nocov end
