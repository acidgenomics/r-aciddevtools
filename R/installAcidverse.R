## nocov start



#' Install Acid Genomics packages
#'
#' @export
#' @note Updated 2022-04-15.
#'
#' @inheritParams params
#'
#' @return Status from `install()`.
#'
#' @examples
#' ## > installAcidverse()
installAcidverse <- function(reinstall = FALSE) {
    message("Installing Acid Genomics packages.")
    install(
        pkgs = c(
            "AcidTest",
            "goalie"
        ),
        dependencies = FALSE,
        reinstall = reinstall
    )
    install(
        pkgs = c(
            "AcidGenerics",
            "AcidRoxygen",
            "AcidCLI",
            "AcidBase",
            "syntactic",
            "pipette",
            "AcidPlyr",
            "AcidGenomes",
            "AcidExperiment",
            "AcidSingleCell",
            "basejump",
            "koopa",
            "AcidPlots",
            "DESeqAnalysis",
            "AcidGSEA",
            "bcbioBase",
            "bcbioRNASeq",
            "bcbioSingleCell",
            "Cellosaurus",
            "DepMapAnalysis",
            "cBioPortalAnalysis",
            "Chromium",
            "pointillism",
            "EggNOG",
            "PANTHER",
            "WormBase"
        ),
        dependencies = TRUE,
        reinstall = reinstall
    )
}



## nocov end
