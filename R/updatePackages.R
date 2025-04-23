#' Update all installed packages
#'
#' @export
#' @note Updated 2023-05-17.
#'
#' @inheritParams params
#'
#' @return `logical`.
#' Validity check return from `valid`.
#'
#' @examples
#' ## > updatePackages()
updatePackages <-
    function(lib = .libPaths()[[1L]]) {
        # nolint
        .installIfNecessary("BiocManager")
        stopifnot(.requireNamespaces("BiocManager"))
        ## > warn <- getOption(x = "warn")
        ## > options("warn" = 2L) # nolint
        lib <- .realpath(lib)
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
            "Bioconductor",
            "CRAN",
            lib
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
                "GitHub",
                lib
            ))
            .installIfNecessary("remotes")
            stopifnot(.requireNamespaces("remotes"))
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
        ## > options("warn" = warn) # nolint
        valid()
    }
