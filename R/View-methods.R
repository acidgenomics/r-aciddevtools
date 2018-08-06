#' Invoke a Data Viewer
#'
#' @rdname View
#' @name View
#' @export
#'
#' @inherit utils::View
NULL



# Methods ======================================================================
# FIXME This will open X11 on the Mac
#' @rdname View
#' @export
setMethod(
    "View",
    "ANY",
    function(x, title) {
        utils::View(x, title)
    }
)



#' @rdname View
#' @export
setMethod(
    "View",
    "DataFrame",
    function(x, title) {
        View(as.data.frame(x), title)
    }
)
