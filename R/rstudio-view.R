#' View object in RStudio viewer
#'
#' This variant performs internal coercion to data.frame, so we can easily
#' view S4 DataFrame objects.
#'
#' @export
#' @note Updated 2019-10-19.
#'
#' @inheritParams params
#'
#' @return Invisible `NULL`.
#'   This function puts up a window and returns immediately.
#'   In RStudio, this will open a tabbed window.
#'
#' @examples
#' view(mtcars)
view <- function(object) {
    stopifnot(requireNamespace("methods", quietly = TRUE))
    ## Coerce S4 object, if applicable.
    if (methods::is(object, "DataFrame")) {
        object <- as.data.frame(object)
    }
    if (!isTRUE(nzchar(Sys.getenv("RSTUDIO_USER_IDENTITY")))) {
        stopifnot(requireNamespace("utils", quietly = TRUE))
        View <- utils::View  # nolint
    }
    View(object)
}
