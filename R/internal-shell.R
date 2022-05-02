#' Split stdout string into a character vector
#'
#' @note Updated 2022-05-02.
#' @noRd
.splitStdout <- function(x) {
    .assert(
        is.list(x),
        .isSubset("stdout", names(x))
    )
    strsplit(x = x[["stdout"]], split = "\n", fixed = TRUE)[[1L]]
}



#' Extract a simple string from stdout return
#'
#' @note Updated 2022-05-02.
#' @noRd
.stdoutString <- function(x) {
    x <- .splitStdout(x)
    .assert(.isString(x))
    x
}
