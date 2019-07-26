#' R documentation table
#'
#' @param x `data.frame`.
#'
#' @return Console output.
#' @export
#'
#' @seealso http://r-pkgs.had.co.nz/man.html

## Updated 2019-07-26.
tabular <- function(x) {
    assert(is.data.frame(x))
    align <- function(x) {
        if (is.numeric(x)) {
            "r"
        } else {
            "l"
        }
    }
    align <- vapply(x, align, character(1L))
    cols <- lapply(x, format)
    contents <- do.call(
        what = "paste",
        args = c(cols, list(sep = " \\tab ", collapse = "\\cr\n  "))
    )
    out <- paste(
        "\\tabular{",
        paste(align, collapse = ""),
        "}{\n  ",
        contents,
        "\n}\n",
        sep = ""
    )
    cat(out)
}
