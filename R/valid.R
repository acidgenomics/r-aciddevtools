#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2022-07-28.
#'
#' @param ... Passthrough arguments to `BiocManager::valid()`.
#'
#' @return `logical(1)`.
#'
#' @examples
#' valid()
valid <- function(...) {
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    ok <- TRUE
    pkgs <- list("new" = character(), "old" = character())
    suppressWarnings({
        bioc <- BiocManager::valid(
            checkBuilt = TRUE,
            site_repository = "https://r.acidgenomics.com"
        )
    })
    ## Too new.
    if (
        is.list(bioc) &&
            isTRUE("too_new" %in% names(bioc)) &&
            isTRUE(length(bioc[["too_new"]]) > 0L)
    ) {
        pkgs[["new"]] <- append(
            x = pkgs[["new"]],
            values = rownames(bioc[["too_new"]])
        )
    }
    if (length(pkgs[["new"]]) > 0L) {
        ok <- FALSE
        pkgs[["new"]] <- sort(unique(pkgs[["new"]]), method = "radix")
        message(paste(
            "",
            paste(length(pkgs[["new"]]), "pre-release:"),
            paste0(
                "AcidDevTools::install(pkgs = c(",
                toString(paste0("\"", pkgs[["new"]], "\"")),
                "), reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    ## Too old.
    if (
        is.list(bioc) &&
            isTRUE("out_of_date" %in% names(bioc)) &&
            isTRUE(length(bioc[["out_of_date"]]) > 0L)
    ) {
        pkgs[["old"]] <- append(
            x = pkgs[["old"]],
            values = rownames(bioc[["out_of_date"]])
        )
    }
    old <- old.packages(checkBuilt = TRUE)
    if (is.matrix(old)) {
        pkgs[["old"]] <- append(
            x = pkgs[["old"]],
            values = rownames(old)
        )
    }
    if (length(pkgs[["old"]]) > 0L) {
        ok <- FALSE
        pkgs[["old"]] <- sort(unique(pkgs[["old"]]), method = "radix")
        message(paste(
            "",
            paste(length(pkgs[["old"]]), "outdated:"),
            paste0(
                "AcidDevTools::install(pkgs = c(",
                toString(paste0("\"", pkgs[["old"]], "\"")),
                "), reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    if (isFALSE(ok)) {
        message("\nR package library is not valid.")
    }
    invisible(ok)
}
