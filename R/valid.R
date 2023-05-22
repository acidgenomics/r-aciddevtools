#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2023-05-22.
#'
#' @section Library location:
#'
#' Calling `.libPaths()[[1L]]` internally here. Alternatively, can use
#' `.Library.site` instead. Ensuring we exclude `.Library` here, to avoid
#' unwanted messages about outdated system packages.
#'
#' @return `logical(1)`.
#'
#' @examples
#' ## > valid()
valid <- function() {
    stopifnot(.requireNamespaces(c("BiocManager", "utils")))
    dict <- list()
    dict[["checkBuilt"]] <- TRUE
    dict[["libLoc"]] <- .libPaths()[[1L]] # nolint
    dict[["type"]] <- getOption("pkgType")
    dict[["type"]] <- switch(
        EXPR = dict[["type"]],
        "both" = "binary",
        dict[["type"]]
    )
    pkgs <- list("new" = character(), "old" = character())
    suppressWarnings({
        bioc <- BiocManager::valid(
            lib.loc = dict[["libLoc"]],
            type = dict[["type"]],
            checkBuilt = dict[["checkBuilt"]],
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
    suppressWarnings({
        old <- utils::old.packages(
            lib.loc = dict[["libLoc"]],
            checkBuilt = dict[["checkBuilt"]],
            type = dict[["type"]]
        )
    })
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
