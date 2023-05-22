#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2023-05-22.
#'
#' @param ... Passthrough arguments to `BiocManager::valid()`.
#'
#' @return `logical(1)`.
#'
#' @examples
#' ## > valid()
valid <- function(...) {
    stopifnot(.requireNamespaces(c("BiocManager", "utils")))
    pkgs <- list("new" = character(), "old" = character())
    type <- getOption("pkgType")
    type <- switch(EXPR = type, "both" = "binary", type)
    suppressWarnings({
        bioc <- BiocManager::valid(
            type = type,
            checkBuilt = TRUE,
            site_repository = "https://r.acidgenomics.com"
        )
    })
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
    ## Ensure we exclude `.Library` here, to avoid unwanted messages about
    ## outdated system packages.
    old <- utils::old.packages(lib.loc = .Library.site, checkBuilt = TRUE)
    if (is.matrix(old)) {
        pkgs[["old"]] <- append(pkgs[["old"]], values = rownames(old))
    }
    if (length(pkgs[["new"]]) > 0L || length(pkgs[["old"]]) > 0L) {
        ok <- FALSE
        message("R package library is not valid.")
    } else {
        ok <- TRUE
    }
    if (length(pkgs[["new"]]) > 0L) {
        pkgs[["new"]] <- sort(unique(pkgs[["new"]]), method = "radix")
        message(paste(
            "",
            paste(length(pkgs[["new"]]), "pre-release:"),
            paste0(
                "AcidDevTools::install(pkgs = ",
                if (length(pkgs[["new"]]) > 1L) {
                    "c("
                },
                toString(paste0("\"", pkgs[["new"]], "\"")),
                if (length(pkgs[["new"]]) > 1L) {
                    ")"
                },
                ", reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    if (length(pkgs[["old"]]) > 0L) {
        pkgs[["old"]] <- sort(unique(pkgs[["old"]]), method = "radix")
        message(paste(
            "",
            paste(length(pkgs[["old"]]), "outdated:"),
            paste0(
                "AcidDevTools::install(pkgs = ",
                if (length(pkgs[["old"]]) > 1L) {
                    "c("
                },
                toString(paste0("\"", pkgs[["old"]], "\"")),
                if (length(pkgs[["old"]]) > 1L) {
                    ")"
                },
                ", reinstall = TRUE)"
            ),
            sep = "\n"
        ))
    }
    invisible(ok)
}
