#' R documentation table
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @param x `data.frame`.
#'
#' @return Console output.
#'
#' @seealso http://r-pkgs.had.co.nz/man.html
tabular <- function(x) {
    stopifnot(is.data.frame(x))
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
