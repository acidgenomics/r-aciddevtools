#' View object in RStudio viewer
#'
#' This variant performs internal coercion to data.frame, so we can easily
#' view S4 DataFrame objects.
#'
#' @export
#' @note Updated 2020-04-09.
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
    requireNamespaces(c("goalie", "methods", "utils"))
    ## Coerce S4 object, if applicable.
    if (isAny(object, c("DataFrame", "GRanges"))) {
        object <- as.data.frame(object)
    }
    if (!isTRUE(nzchar(Sys.getenv("RSTUDIO_USER_IDENTITY")))) {
        View <- utils::View  # nolint
    }
    View(object)
}
