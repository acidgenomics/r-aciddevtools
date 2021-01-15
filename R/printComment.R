#' Print as comment
#'
#' @export
#' @note Updated 2021-01-15.
#'
#' @param ... Passthrough to `print()`.
#' @param prefix Comment prefix to use. RStudio, roxygen, and ESS prefixes
#'   are supported.
#' @param width `integer(1L)`.
#'   Desired output width.
#'   Defaults to 80 characters.
#'
#' @return Console output.
printComment <- function(
    ...,
    prefix = c(
        "##",
        "## >",
        "#'",
        "#' >",
        "#",
        "# >"
    ),
    width = 80L
) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    prefix <- match.arg(prefix)
    ## Subtract the width of the prefix, including a space.
    width <- width - (length(prefix) + 1L)
    defaultWidth <- getOption("width")
    options(width = width)
    out <- utils::capture.output(print(...))
    out <- paste(prefix, out)
    cat(out, sep = "\n")
    ## Reset the width back to default.
    options(width = defaultWidth)
}



#' @rdname printComment
#' @export
pc <- function(...) {
    printComment(...)
}
