#' Update outdated dependencies
#'
#' Supports Bioconductor, CRAN, and GitHub packages via BiocManager.
#'
#' @export
#' @note Updated 2019-08-15.
#'
#' @param pkg `character(1)`.
#'   Package path. Must contain a `DESCRIPTION` file.
#' @param type `character`.
#'   Dependency type.
#'
#' @return `BiocManager::install()` call if packages need an update.
updateDeps <- function(
    pkg = ".",
    type = c("Depends", "Imports")
) {
    stopifnot(file.exists(file.path(pkg, "DESCRIPTION")))
    pkgname <- desc_get_field(file = pkg, key = "Package")
    message(sprintf("Checking %s dependencies.", pkgname))
    ## Get dependency versions.
    deps <- desc_get_deps(pkg)
    ## Drop base R.
    keep <- deps[["package"]] != "R"
    deps <- deps[keep, , drop = FALSE]
    ## Keep only requested dependency types.
    keep <- deps[["type"]] %in% type
    deps <- deps[keep, , drop = FALSE]
    ## Only keep dependencies with a suggested minimum version.
    keep <- grepl("^>= ", deps[["version"]])
    deps <- deps[keep, , drop = FALSE]
    deps[["version"]] <- sub("^>= ", "", deps[["version"]])
    colnames(deps)[colnames(deps) == "version"] <- "required"
    ## Get current installed versions.
    current <- installed.packages()[, c("Package", "Version"), drop = FALSE]
    colnames(current)[colnames(current) == "Package"] <- "package"
    colnames(current)[colnames(current) == "Version"] <- "current"
    ## Create an index column so merge operation doesn't resort.
    deps[["idx"]] <- seq_len(nrow(deps))
    deps <- merge(
        x = deps,
        y = current,
        by = "package",
        all.x = TRUE,
        sort = FALSE
    )
    deps <- deps[order(deps[["idx"]]), , drop = FALSE]
    deps[["idx"]] <- NULL
    ## Rename package in data frame to remote name, if necessary.
    remotes <- desc_get_remotes(pkg)
    if (length(remotes) > 0L) {
        x <- remotes
        table <- deps[["package"]]
        match <- match(x = basename(x), table = table)
        for (i in seq_along(match)) {
            if (is.na(match[i])) next
            table[match[i]] <- remotes[i]
        }
        deps[["package"]] <- table
    }
    ## Get a logical vector of which packages pass requirement.
    deps[["pass"]] <- mapply(
        x = as.character(deps[["current"]]),
        y = as.character(deps[["required"]]),
        FUN = function(x, y) {
            if (is.na(x)) return(FALSE)
            x <- package_version(x)
            y <- package_version(y)
            x >= y
        },
        SIMPLIFY = TRUE,
        USE.NAMES = FALSE
    )
    if (!all(deps[["pass"]])) {
        message(paste(
            capture.output(print(deps, row.names = FALSE)),
            collapse = "\n"
        ))
    }
    ## Filter dependencies by which packages need an update.
    deps <- deps[!deps[["pass"]], , drop = FALSE]
    if (identical(nrow(deps), 0L)) {
        message(sprintf("All %s dependencies are up-to-date.", pkgname))
        return(invisible())
    }
    pkgs <- deps[["package"]]
    message(sprintf("Updating %s dependencies: %s.", pkgname, toString(pkgs)))
    install(pkgs = pkgs, ask = FALSE)
}
