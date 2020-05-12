#' Print as comment
#'
#' @export
#' @note Updated 2020-05-12.
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
    ## Always set width at 80 characters.
    defaultWidth <- getOption("width")
    options(width = width)
    out <- utils::capture.output(print(...))
    out <- paste(prefix, out)
    cat(out, sep = "\n")
    ## Reset the width back to default.
    options(width = defaultWidth)
}
