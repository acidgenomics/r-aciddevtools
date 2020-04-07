.require <- function(pkgs) {
    ok <- vapply(
        X = pkgs,
        FUN = requireNamespace,
        FUN.VALUE = logical(1L),
        USE.NAMES = TRUE,
        quietly = TRUE
    )
    if (!isTRUE(all(ok))) {
        stop(sprintf(
            fmt = "Not installed: %s",
            toString(names(ok)[!ok])
        ))
    }
    invisible(TRUE)
}
