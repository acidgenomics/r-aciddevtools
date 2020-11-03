#' Install Acid Genomics packages
#'
#' @export
#' @note Updated 2020-11-03.
#'
#' @return Status from [install()].
#'
#' @examples
#' ## > installAcidverse()
installAcidverse <- function() {
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
            "bb8",                                      # Infrastructure
            "bcbioRNASeq",                              # RNASeq
            "bcbioSingleCell",                          # SingleCell
            "cBioPortalAnalysis",                       # CancerData
            "goalie",                                   # Infrastructure
            "pointillism",                              # SingleCell
            "syntactic"                                 # Infrastructure
        ),
        reinstall = FALSE
    )
}
