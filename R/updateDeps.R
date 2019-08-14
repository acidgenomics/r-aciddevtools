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
    assert(file.exists(file.path(pkg, "DESCRIPTION")))
    ## Get dependency versions.
    deps <- desc_get_deps(pkg)
    rownames(deps) <- deps[["package"]]
    ## Drop base R.
    keep <- deps[["package"]] != "R"
    deps <- deps[keep, , drop = FALSE]
    ## Only keep dependencies with a suggested minimum version.
    keep <- grepl("^>= ", deps[["version"]])
    deps <- deps[keep, , drop = FALSE]
    deps[["version"]] <- sub("^>= ", "", deps[["version"]])
    colnames(deps)[colnames(deps) == "version"] <- "required"
    ## Get current installed versions.
    current <- installed.packages()[, "Version", drop = FALSE]
    colnames(current)[colnames(current) == "Version"] <- "current"
    current <- current[rownames(deps), , drop = FALSE]
    deps <- cbind(deps, current)
    ## Get a logical vector of which packages pass requirement.
    ok <- mapply(
        e1 = package_version(deps[["current"]]),
        e2 = package_version(deps[["required"]]),
        FUN = `>=`,
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
