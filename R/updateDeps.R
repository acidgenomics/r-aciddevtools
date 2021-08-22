## nocov start



#' Update outdated dependencies
#'
#' Supports Bioconductor, CRAN, and GitHub packages via BiocManager.
#'
#' This is used by [r-cmd-check][] for continuous integration (CI) testing.
#'
#' [r-cmd-check]: https://github.com/acidgenomics/r-cmd-check
#'
#' @export
#' @note Updated 2020-10-20.
#'
#' @param pkg `character(1)`.
#'   Package path. Must contain a `DESCRIPTION` file.
#' @param type `character`.
#'   Dependency type.
#'   See `utils::install.packages()` for details.
#'
#' @seealso
#' - desc package.
#' - `utils::packageDescription()`.
#'
#' @return `BiocManager::install()` call if packages need an update.
updateDeps <- function(
    pkg = ".",
    type = c(
        "Depends",
        "Imports",
        "LinkingTo",
        "Suggests",
        "Enhances"
    )
) {
    stopifnot(
        requireNamespace("BiocManager", quietly = TRUE),
        requireNamespace("remotes", quietly = TRUE),
        requireNamespace("utils", quietly = TRUE),
        isTRUE(file.exists(file.path(pkg, "DESCRIPTION")))
    )
    ## Get current installed versions.
    current <- utils::installed.packages()
    current <- current[, c("Package", "Version"), drop = FALSE]
    colnames(current)[colnames(current) == "Package"] <- "package"
    colnames(current)[colnames(current) == "Version"] <- "current"
    pkgname <- desc::desc_get_field(file = pkg, key = "Package")
    message(sprintf("Checking %s dependencies.", pkgname))
    ## Get dependency versions.
    df <- desc::desc_get_deps(pkg)
    stopifnot(is.data.frame(df))
    ## Drop base R row.
    keep <- df[["package"]] != "R"
    df <- df[keep, , drop = FALSE]
    ## Keep only requested dependency types.
    keep <- df[["type"]] %in% type
    df <- df[keep, , drop = FALSE]
    ## Create a vector of packages we need to update.
    pkgs <- character()
    ## Packages without a version requirement.
    noVersion <- df[which(df[["version"]] == "*"), "package", drop = TRUE]
    noVersionMissing <- noVersion[which(!noVersion %in% rownames(current))]
    pkgs <- c(pkgs, noVersionMissing)
    ## Packages less than or equal to a specific version.
    keep <- grepl("^>= ", df[["version"]])
    df <- df[keep, , drop = FALSE]
    df[["version"]] <- sub("^>= ", "", df[["version"]])
    colnames(df)[colnames(df) == "version"] <- "required"
    ## Create an index column so merge operation doesn't resort.
    df[["idx"]] <- seq_len(nrow(df))
    df <- merge(
        x = df,
        y = current,
        by = "package",
        all.x = TRUE,
        sort = FALSE
    )
    df <- df[order(df[["idx"]]), , drop = FALSE]
    df[["idx"]] <- NULL
    ## Rename package in data frame to remote name, if necessary.
    remotes <- desc::desc_get_remotes(pkg)
    if (length(remotes) > 0L) {
        x <- remotes
        table <- df[["package"]]
        match <- match(x = basename(x), table = table)
        for (i in seq_along(match)) {
            if (is.na(match[i])) next
            table[match[i]] <- remotes[i]
        }
        df[["package"]] <- table
    }
    ## Get a logical vector of which packages pass requirement.
    df[["pass"]] <- mapply(
        x = as.character(df[["current"]]),
        y = as.character(df[["required"]]),
        FUN = function(x, y) {
            if (is.na(x)) return(FALSE)
            x <- package_version(x)
            y <- package_version(y)
            x >= y
        },
        SIMPLIFY = TRUE,
        USE.NAMES = FALSE
    )
    if (!all(df[["pass"]])) {
        message(paste(
            utils::capture.output(print(df, row.names = FALSE)),
            collapse = "\n"
        ))
    }
    ## Filter dependencies by which packages need an update.
    df <- df[!df[["pass"]], , drop = FALSE]
    pkgs <- c(pkgs, df[["package"]])
    if (length(pkgs) > 0L) {
        message(sprintf(
            "Updating %s dependencies: %s.",
            pkgname, toString(pkgs)
        ))
        install(pkgs = pkgs, reinstall = TRUE)
    } else {
        message(sprintf(
            "All %s dependencies are up-to-date.",
            pkgname
        ))
        invisible(NULL)
    }
}



## nocov end
