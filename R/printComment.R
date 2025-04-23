#' Print as comment
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @param ... Passthrough to `print()`.
#'
#' @param prefix Comment prefix to use. RStudio, roxygen, and ESS prefixes
#' are supported.
#'
#' @param width `integer(1L)`.
#' Desired output width.
#' Defaults to 80 characters.
#'
#' @return Console output.
#'
#' @examples
#' printComment(c("hello", "world"))
printComment <-
    function(
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
        stopifnot(.requireNamespaces(c("utils", "withr")))
        prefix <- match.arg(prefix)
        ## Subtract the width of the prefix, including a space.
        width <- width - (length(prefix) + 1L)
        withr::with_options(
            new = list("width" = width),
            code = {
                out <- utils::capture.output(print(...))
                out <- paste(prefix, out)
                cat(out, sep = "\n")
            }
        )
    }
