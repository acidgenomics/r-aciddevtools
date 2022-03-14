## nocov start



#' Install Acid Genomics packages
#'
#' @export
#' @note Updated 2021-05-12.
#'
#' @return Status from `install()`.
#'
#' @examples
#' ## > installAcidverse()
installAcidverse <- function() {
    message("Installing Acid Genomics packages.")
    install(
        pkgs = c(
            "AcidGSEA",
            "AcidGenerics",
            "AcidPlots",
            "AcidRoxygen",
            "AcidTest",
            "Cellosaurus",
            "Chromium",
            "DESeqAnalysis",
            "DepMapAnalysis",
            "EggNOG",
            "PANTHER",
            "WormBase",
            "basejump",
            "bcbioBase",
            "bcbioRNASeq",
            "bcbioSingleCell",
            "cBioPortalAnalysis",
            "goalie",
            "koopa",
            "pointillism",
            "syntactic"
        ),
        dependencies = TRUE,
        reinstall = FALSE
    )
}



## nocov end
