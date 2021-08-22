#' Update all installed packages
#'
#' @export
#' @note Updated 2021-08-22.
#'
#' @inheritParams params
#'
#' @return Invisible `TRUE` or console output.
#'   Whether installation passes Bioconductor validity checks.
#'   See `BiocManager::valid()` for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function(
    lib = .libPaths()[[1L]]
) {
    warn <- getOption("warn")
    options("warn" = 2L)
    if (isFALSE(dir.exists(lib))) {
        dir.create(lib)
    }
    lib <- normalizePath(lib, mustWork = TRUE)
    if (!identical(
        x = lib,
        y = normalizePath(.libPaths()[[1L]], mustWork = TRUE)
    )) {
        .libPaths(new = lib, include.site = TRUE)
    }
    .installIfNecessary("BiocManager")
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    biocInstalled <- BiocManager::version()
    biocCurrent <- currentBiocVersion()
    if (isTRUE(biocInstalled < biocCurrent)) {
        message(sprintf(
            "Updating %s to %s.",
            "Bioconductor", as.character(biocCurrent)
        ))
        BiocManager::install(
            update = TRUE,
            ask = FALSE,
            version = biocCurrent,
            lib = lib
        )
    }
    message("Updating Bioconductor and CRAN packages.")
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
        message("Updating GitHub packages.")
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
    out <- .valid()
    options("warn" = warn)
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}
