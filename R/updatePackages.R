#' Update all installed packages
#'
#' @export
#' @note Updated 2020-11-11.
#'
#' @return Invisible `TRUE` or console output.
#'   Whether installation passes Bioconductor validity checks.
#'   See [BiocManager::valid()] for details.
#'
#' @examples
#' ## > updatePackages()
updatePackages <- function() {
    warn <- getOption("warn")
    options("warn" = 2L)
    .installIfNecessary(c("BiocManager", "remotes"))
    ## Clean up CRAN removals and abandoned GitHub packages first.
    suppressMessages({
        uninstall(
            pkgs = c(
                "SDMTools",
                "bioverbs",
                "freerange",
                "pfgsea",
                "transformer"
            )
        )
    })
    stopifnot(requireNamespace("BiocManager", quietly = TRUE))
    biocInstalled <- BiocManager::version()
    biocCurrent <- currentBiocVersion()
    if (isTRUE(biocInstalled < biocCurrent)) {
        message(sprintf(
            "Updating Bioconductor to %s.",
            as.character(biocCurrent)
        ))
        BiocManager::install(
            update = TRUE,
            ask = FALSE,
            version = biocCurrent
        )
    }
    message("Updating Bioconductor and CRAN packages.")
    BiocManager::install(
        pkgs = character(),
        site_repository = "https://r.acidgenomics.com",
        update = TRUE,
        ask = FALSE,
        checkBuilt = TRUE
    )
    if (isTRUE(nzchar(Sys.getenv("GITHUB_PAT")))) {
        message("Updating GitHub packages.")
        stopifnot(requireNamespace("remotes", quietly = TRUE))
        ## Suppressing messages about packages ahead of CRAN here.
        suppressMessages({
            remotes::update_packages(
                packages = TRUE,
                upgrade = "always",
                repos = c(
                    "https://r.acidgenomics.com",
                    BiocManager::repositories()
                )
            )
        })
    }
    out <- BiocManager::valid()
    options("warn" = warn)
    if (isTRUE(out)) {
        invisible(TRUE)
    } else {
        out
    }
}
