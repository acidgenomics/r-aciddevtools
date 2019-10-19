#' Print as comment
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @param ... Passthrough to `print()`.
#' @param prefix Comment prefix to use. RStudio, roxygen, and ESS prefixes
#'   are supported.
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
    )
) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    prefix <- match.arg(prefix)
    out <- utils::capture.output(print(...))
    out <- paste(prefix, out)
    cat(out, sep = "\n")
}
