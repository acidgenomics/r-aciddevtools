## nocov start



#' Update all installed packages
#'
#' @export
#' @note Updated 2021-08-23.
#'
#' @inheritParams params
#'
#' @return Invisible `TRUE` or console output.
#' Whether installation passes Bioconductor validity checks.
#' See `BiocManager::valid()` for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function(lib = .libPaths()[[1L]]) {
    warn <- getOption(x = "warn")
    options("warn" = 2L)
    lib <- normalizePath(lib, mustWork = TRUE)
    .installIfNecessary("BiocManager")
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    biocInstalled <- BiocManager::version()
    biocCurrent <- currentBiocVersion()
    if (isTRUE(biocInstalled < biocCurrent)) {
        message(sprintf(
            "Updating %s to %s in '%s'.",
            "Bioconductor",
            as.character(biocCurrent),
            lib
        ))
        BiocManager::install(
            update = TRUE,
            ask = FALSE,
            version = biocCurrent,
            lib = lib
        )
    }
    message(sprintf(
        "Updating %s and %s packages in '%s'.",
        "Bioconductor", "CRAN", lib
    ))
    BiocManager::repositories()
    BiocManager::install(
        pkgs = character(),
        site_repository = "https://r.acidgenomics.com",
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE,
        lib = lib
    )
    if (isTRUE(nzchar(Sys.getenv("GITHUB_PAT")))) {
        message(sprintf(
            "Updating %s packages in '%s'.",
            "GitHub", lib
        ))
        .installIfNecessary("remotes")
        stopifnot(requireNamespace("remotes", quietly = TRUE))
        ## Suppressing messages about packages ahead of CRAN here.
        suppressMessages({
            remotes::update_packages(
                packages = TRUE,
                upgrade = "always",
                repos = c(
                    "https://r.acidgenomics.com",
                    BiocManager::repositories()
                ),
                lib = lib
            )
        })
    }
    out <- .valid(lib = lib)
    options("warn" = warn)
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}



## nocov end
