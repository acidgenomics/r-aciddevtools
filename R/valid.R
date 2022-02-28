#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2022-02-28.
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
    if (isTRUE("too_new" %in% names(x))) {
        pkgs <- sort(
            x = rownames(x[["too_new"]]),
            method = "radix"
        )
        message(paste(
            "",
            paste(length(pkgs), "pre-release:"),
            paste0(
                "BiocManager::install(pkgs = c(",
                paste(paste0("\"", pkgs, "\""), collapse = ", "),
                "), update = TRUE, ask = FALSE)"
            ),
            sep = "\n"
        ))
    }
    if (isTRUE("out_of_date" %in% names(x))) {
        pkgs <- sort(
            x = rownames(x[["out_of_date"]]),
            method = "radix"
        )
        message(paste(
            "",
            paste(length(pkgs), "outdated:"),
            paste0(
                "BiocManager::install(pkgs = c(",
                paste(paste0("\"", pkgs, "\""), collapse = ", "),
                "), update = TRUE, ask = FALSE)"
            ),
            sep = "\n"
        ))
    }
    return(invisible(FALSE))
}
