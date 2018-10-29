#' R Documentation Table
#' @export
#' @param df `data.frame`.
#' @seealso http://r-pkgs.had.co.nz/man.html
tabular <- function(df) {
    assert_that(is.data.frame(df))
    align <- function(x) {
        if (is.numeric(x)) {
            "r"
        } else {
            "l"
        }
    }
    col_align <- vapply(df, align, character(1))
    cols <- lapply(df, format)
    contents <- do.call(
        what = "paste",
        args = c(cols, list(sep = " \\tab ", collapse = "\\cr\n  "))
    )
    out <- paste(
        "\\tabular{",
        paste(col_align, collapse = ""),
        "}{\n  ",
        contents,
        "\n}\n",
        sep = ""
    )
    cat(out)
}
