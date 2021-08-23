#' R documentation table
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @param x `data.frame`.
#'
#' @return Console output.
#'
#' @seealso
#' - http://r-pkgs.had.co.nz/man.html
#'
#' @examples
#' df <- data.frame(
#'     "aaa" = seq(from = 1L, to = 4L),
#'     "bbb" = seq(from = 2L, to = 5L),
#'     "ccc" = seq(from = 3L, to = 6L),
#'     row.names = c("AAA", "BBB", "CCC", "DDD")
#' )
#' tabular(df)
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
