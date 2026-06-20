#' Validate installed package versions against correct versions
#'
#' @export
#' @note Updated 2024-09-04.
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
    if (!nzchar(system.file(package = "BiocManager"))) {
        message("BiocManager is required for valid().")
        return(invisible(FALSE))
    }
    dict <- list()
    dict[["checkBuilt"]] <- TRUE
    dict[["libLoc"]] <- .libPaths()[[1L]] # nolint
    dict[["type"]] <- getOption("pkgType")
    pkgs <- list("new" = character(), "old" = character())
    suppressMessages({
        suppressWarnings({
            bioc <- BiocManager::valid(
                lib.loc = dict[["libLoc"]],
                type = dict[["type"]],
                checkBuilt = dict[["checkBuilt"]],
                site_repository = "https://r.acidgenomics.com"
            )
        })
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
        outOfDate <- bioc[["out_of_date"]]
        ## Only flag packages where a binary is available at the newer version.
        ## Bioconductor source and binary builds are not always in sync;
        ## flagging source-only updates forces compilation with no benefit
        ## on a binary R installation.
        if (isTRUE(nrow(outOfDate) > 0L)) {
            binAvail <- tryCatch(
                available.packages(
                    repos = BiocManager::repositories(),
                    type = "binary",
                    filters = NULL
                ),
                error = function(e) NULL
            )
            if (!is.null(binAvail)) {
                hasBinary <- vapply(
                    X = rownames(outOfDate),
                    FUN = function(pkg) {
                        isTRUE(
                            pkg %in% rownames(binAvail) &&
                                package_version(
                                    binAvail[pkg, "Version"]
                                ) > package_version(
                                    outOfDate[pkg, "Installed"]
                                )
                        )
                    },
                    FUN.VALUE = logical(1L)
                )
                outOfDate <- outOfDate[hasBinary, , drop = FALSE]
            }
        }
        pkgs[["old"]] <- append(
            x = pkgs[["old"]],
            values = rownames(outOfDate)
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
