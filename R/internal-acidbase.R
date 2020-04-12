#' Require package namespaces
#' @note Updated 2020-04-12.
#' @noRd
#' @seealso `acidbase::requireNamespaces`.
requireNamespaces <- function(packages) {
    ok <- vapply(
        X = packages,
        FUN = requireNamespace,
        FUN.VALUE = logical(1L),
        USE.NAMES = TRUE,
        quietly = TRUE
    )
    if (!isTRUE(all(ok))) {
        stop(sprintf(
            fmt = "Namespace failure: %s",
            toString(names(ok)[!ok])
        ))
    }
    ## Returning boolean flag here, for use inside `stopifnot()` / `stopifnot()`.
    invisible(TRUE)
}
