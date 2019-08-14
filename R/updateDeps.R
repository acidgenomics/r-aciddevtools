#' Update outdated dependencies
#'
#' Supports Bioconductor, CRAN, and GitHub packages via BiocManager.
#'
#' @export
#' @note Updated 2019-08-13.
#'
#' @param pkg `character(1)`.
#'   Package path. Must contain a `DESCRIPTION` file.
#'
#' @return `BiocManager::install()` call if packages need an update.
updateDeps <- function(pkg = ".") {
    stopifnot(file.exists(file.path(pkg, "DESCRIPTION")))
    ## Get dependency versions.
    deps <- desc_get_deps(pkg)
    ## Drop base R.
    keep <- deps[["package"]] != "R"
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
    ## Get a logical vector of which packages pass requirement.
    ok <- mapply(
        x = deps[["current"]],
        y = deps[["required"]],
        FUN = function(x, y) {
            if (is.na(x)) return(FALSE)
            x <- package_version(x)
            y <- package_version(y)
            x >= y
        },
        SIMPLIFY = TRUE,
        USE.NAMES = TRUE
    )
    ## Filter dependencies by which packages need an update.
    deps <- deps[!ok, , drop = FALSE]
    if (identical(nrow(deps), 0L)) {
        message("All dependencies are up-to-date.")
        return(invisible())
    }
    ## Rename package in data frame to remote name, if necessary.
    remotes <- desc_get_remotes()
    match <- na.omit(match(
        x = basename(remotes),
        table = deps[["package"]]
    ))
    deps[["package"]][match] <- remotes[match]
    install(pkgs = deps[["package"]], update = FALSE, ask = FALSE)
}
