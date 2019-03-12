#' Print as comment
#' @export
#' @param ... Passthrough to `print()`.
#' @param prefix Comment prefix to use.
#'
printComment <- function(
    ...,
    prefix = c(
        "# >",
        "#",
        "#' >",
        "#'",
        "## >",
        "##"
    )
) {
    prefix <- match.arg(prefix)
    out <- capture.output(print(...))
    # Prepend the prefix to print return.
    out <- paste(prefix, out)
    cat(out, sep = "\n")
}
