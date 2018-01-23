#' View Data Frame
#'
#' Utility function for quickly viewing an object as a [data.frame].
#'
#' This is particularly useful for opening S4 class [DataFrame] objects in
#' RStudio using the nicer [data.frame] tabbed graphical interface.
#'
#' @return No return.
#' @export
ViewDF <- function(object) {
    object %>%
        as.data.frame() %>%
        View()
}
