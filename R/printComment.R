#' Print as comment
#'
#' @export
#' @note Updated 2020-04-12.
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
    prefix <- match.arg(prefix)
    out <- capture.output(print(...))
    out <- paste(prefix, out)
    cat(out, sep = "\n")
}
