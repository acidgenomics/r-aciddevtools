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
            "AcidGSEA",                                 # RNASeq
            "AcidGenerics",                             # Infrastructure
            "AcidPlots",                                # Visualization
            "AcidRoxygen",                              # Infrastructure
            "AcidTest",                                 # Infrastructure
            "Cellosaurus",                              # CancerData
            "Chromium",                                 # SingleCell
            "DESeqAnalysis",                            # RNASeq
            "DepMapAnalysis",                           # CancerData
            "EggNOG",                                   # Annotation
            "PANTHER",                                  # Annotation
            "WormBase",                                 # Annotation
            "basejump",                                 # Infrastructure
            "bcbioBase",                                # Infrastructure
            "bcbioRNASeq",                              # RNASeq
            "bcbioSingleCell",                          # SingleCell
            "cBioPortalAnalysis",                       # CancerData
            "goalie",                                   # Infrastructure
            "koopa",                                    # Infrastructure
            "pointillism",                              # SingleCell
            "syntactic"                                 # Infrastructure
        ),
        dependencies = TRUE,
        reinstall = FALSE
    )
}



## nocov end
