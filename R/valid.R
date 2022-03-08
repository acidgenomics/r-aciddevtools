#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2022-03-08.
#'
#' @param ... Passthrough arguments to `BiocManager::valid()`.
#'
#' @return `logical(1)`.
#'
#' @examples
#' valid()
valid <- function(...) {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    suppressWarnings({
        x <- BiocManager::valid()
    })
    if (isTRUE(x)) {
        return(invisible(TRUE))
    }
    stopifnot(is.list(x))
    message("R package library is not valid.")
    if (
        isTRUE("too_new" %in% names(x)) &&
        isTRUE(length(x[["too_new"]]) > 0L)
    ) {
        pkgs <- sort(
            x = rownames(x[["too_new"]]),
            method = "radix"
        )
        message(paste(
            "",
            paste(length(pkgs), "pre-release:"),
            paste0(
                "AcidDevTools::install(pkgs = c(",
                paste(paste0("\"", pkgs, "\""), collapse = ", "),
                "), reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    if (
        isTRUE("out_of_date" %in% names(x)) &&
        isTRUE(length(x[["out_of_date"]]) > 0L)
    ) {
        pkgs <- sort(
            x = rownames(x[["out_of_date"]]),
            method = "radix"
        )
        message(paste(
            "",
            paste(length(pkgs), "outdated:"),
            paste0(
                "AcidDevTools::install(pkgs = c(",
                paste(paste0("\"", pkgs, "\""), collapse = ", "),
                "), reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    return(invisible(FALSE))
}
