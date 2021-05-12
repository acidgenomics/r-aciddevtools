#' Install recommended R packages
#'
#' @export
#' @note Updated 2021-05-12.
#'
#' @section tidyverse packages:
#'
#' The [tidyverse][] is a data science meta-package containing: DBI, dplyr,
#' forcats, ggplot2, googledrive, googlesheets4, haven, httr, jsonlite,
#' lubridate, purrr, readr, readxl, rvest, stringr, tibble, tidyr, and xml2.
#'
#' [tidyverse]: https://www.tidyverse.org/packages/
#'
#' @param extra `logical` or `logical(1)`.
#'   Named logical vector of which types of extra packages to install.
#'   Alternatively, can install all extra packages by setting to `TRUE`, or
#'   disable the installation of any extra packages by setting to `FALSE`.
#'
#' @examples
#' ## > installRecommendedPackages()
installRecommendedPackages <- function(
    extra = c(
        "acidverse" = TRUE,
        "annotation" = FALSE,
        "cancer" = TRUE,
        "chipseq" = FALSE,
        "devtools" = TRUE,
        "enrichment" = FALSE,
        "filesystem" = TRUE,
        "general" = TRUE,
        "graphics" = TRUE,
        "models" = TRUE,
        "riboseq" = FALSE,
        "rnaseq" = TRUE,
        "shiny" = TRUE,
        "singlecell" = TRUE,
        "smallrna" = FALSE,
        "tidyverse" = TRUE
    )
) {
    stopifnot(is.logical(extra))
    .install <- function(
        ...,
        reinstall = FALSE,
        dependencies = NA
    ) {
        install(
            ...,
            dependencies = dependencies,
            reinstall = reinstall
        )
    }
    okMsg <- "Installation of R packages was successful."
    ## Enable versioned Bioconductor install.
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
        utils::install.packages("BiocManager")
    }
    biocVersion <- Sys.getenv("BIOC_VERSION")
    if (!isTRUE(nzchar(biocVersion))) {
        biocVersion <- BiocManager::version()
    }
    message(sprintf("Installing Bioconductor %s.", biocVersion))
    BiocManager::install(update = FALSE, ask = FALSE, version = biocVersion)
    ## Default packages =================================================== {{{1
    pkgs <- character()
    ## Tricky to build ---------------------------------------------------- {{{2
    pkgs <- c(
        pkgs,
        "Rcpp",
        "RcppArmadillo",
        "RcppAnnoy",
        "XML",
        "rJava",
        "rgdal",
        "rgl",
        "sf"
    )
    ## CRAN --------------------------------------------------------------- {{{2
    pkgs <- c(
        pkgs,
        "Matrix",
        "R.utils",
        "data.table",
        "future",
        "knitr",
        "magrittr",
        "matrixStats",
        "parallel",
        "reticulate",
        "rmarkdown",
        "sessioninfo",
        "stringi",
        "viridis"
    )
    ## Bioconductor ------------------------------------------------------- {{{2
    pkgs <- c(
        pkgs,
        "AnnotationDbi",
        "AnnotationHub",
        "Biobase",
        "BiocCheck",
        "BiocFileCache",
        "BiocGenerics",
        "BiocNeighbors",
        "BiocParallel",
        "BiocSingular",
        "BiocStyle",
        "BiocVersion",
        "Biostrings",
        "GenomeInfoDb",
        "GenomeInfoDbData",
        "GenomicAlignments",
        "GenomicFeatures",
        "GenomicRanges",
        "IRanges",
        "S4Vectors",
        "SingleCellExperiment",
        "SummarizedExperiment",
        "XVector",
        "ensembldb",
        "rtracklayer",
        "zlibbioc"
    )
    .install(pkgs)
    if (!any(extra)) {
        message(okMsg)
        return(invisible(NULL))
    }
    ## Extra packages ===================================================== {{{1
    pkgs <- character()
    ## Acidverse ---------------------------------------------------------- {{{2
    if (isTRUE(extra[["acidverse"]])) {
        installAcidverse()
    }
    ## CRAN --------------------------------------------------------------- {{{2
    if (isTRUE(extra[["tidyverse"]])) {
        pkgs <- c(pkgs, "tidyverse")
    }
    if (isTRUE(extra[["general"]])) {
        pkgs <- c(
            pkgs,
            "DT",
            "languageserver",  # vscode
            "slam",
            "tidytext"
        )
    }
    if (isTRUE(extra[["cancer"]])) {
        pkgs <- c(
            pkgs,
            "cgdsr"  # cBioPortal
        )
    }
    if (isTRUE(extra[["devtools"]])) {
        pkgs <- c(
            pkgs,
            "R.oo",
            "R6",
            "available",
            "backports",
            "bench",
            "bookdown",
            "box",
            "cli",
            "covr",
            "crayon",
            "dbplyr",
            "desc",
            "devtools",
            "drat",
            "git2r",
            "glue",
            "lintr",
            "lobstr",
            "memoise",
            "packrat",
            "pkgdown",
            "pak",
            "pillar",
            "profvis",
            "processx",
            "ps",
            "rcmdcheck",
            "remotes",
            "reprex",
            "rlang",
            "roxygen2",
            "sloop",
            "snow",
            "styler",
            "testthat",
            "usethis",
            "waldo",
            "xmlparsedata"
        )
    }
    if (isTRUE(extra[["enrichment"]])) {
        pkgs <- c(
            pkgs,
            "gprofiler2",
            "liger"
        )
    }
    if (isTRUE(extra[["filesystem"]])) {
        pkgs <- c(
            pkgs,
            "broom",
            "curl",
            "datapasta",
            "fs",
            "janitor",
            "jsonlite",
            "openxlsx",
            "pzfx",
            "rdrop2",
            "rio",
            "snakecase",
            "vroom"
        )
    }
    if (isTRUE(extra[["graphics"]])) {
        pkgs <- c(
            pkgs,
            "UpSetR",
            "cowplot",
            "dendextend",
            "dendsort",
            "ggdendro",
            "ggpubr",
            "ggrepel",
            "ggrepel",
            "ggridges",
            "ggupset",
            "hexbin",
            "magick",
            "pheatmap",
            "prettyunits",
            "ragg"
        )
    }
    if (isTRUE(extra[["models"]])) {
        pkgs <- c(
            pkgs,
            "NMF",
            "WGCNA",
            "ashr",
            "dynamicTreeCut",
            "fastICA",
            "fastcluster",
            "fastmatch",
            "fdrtool",
            "uwot"
        )
    }
    if (isTRUE(extra[["shiny"]])) {
        pkgs <- c(
            pkgs,
            "htmlwidgets",
            "rsconnect",  # shinyapps.io
            "shiny",
            "shinycssloaders",
            "shinydashboard"
        )
    }
    if (isTRUE(extra[["singlecell"]])) {
        pkgs <- c(pkgs, "Seurat")
    }
    ## Bioconductor ------------------------------------------------------- {{{2
    ## General
    if (isTRUE(extra[["general"]])) {
        pkgs <- c(
            pkgs,
            "DelayedArray",
            "DelayedMatrixStats"
        )
    }
    ## Annotation (i.e. genomes) ------------------------------------------ {{{3
    if (isTRUE(extra[["annotation"]])) {
        pkgs <- c(
            pkgs,
            "ExperimentHub",
            "GEOquery",
            "biomaRt"
        )

    ## >     "AnnotationFilter",                        # Annotation
    ## >     "BSgenome.Hsapiens.NCBI.GRCh38",           # AnnotationData
    ## >     "BSgenome.Hsapiens.UCSC.hg19",             # AnnotationData
    ## >     "BSgenome.Hsapiens.UCSC.hg38",             # AnnotaitonData
    ## >     "BSgenome.Mmusculus.UCSC.mm10",            # AnnotationData
    ## >     "EnsDb.Hsapiens.v75",                      # AnnotationData
    ## >     "EnsDb.Hsapiens.v86",                      # AnnotationData
            "org.Hs.eg.db",                             # AnnotationData
            "org.Mm.eg.db",                             # AnnotationData
            "TxDb.Hsapiens.UCSC.hg19.knownGene",        # AnnotationData
            "TxDb.Hsapiens.UCSC.hg38.knownGene",        # AnnotationData
            "TxDb.Mmusculus.UCSC.mm10.knownGene",       # AnnotationData

    ## Cancer genomics.
            "cBioPortalData"

    ## ChIP-seq.
            "ChIPpeakAnno",                             # ChIPSeq

    ## microRNA-seq.
            "TargetScore",                              # miRNA

    ## Pathways.
            "clusterProfiler",                          # Pathways
            "DOSE",                                     # Pathways
            "GOSemSim",                                 # Pathways
            "GSEABase",                                 # Pathways
            "GSVA",                                     # Pathways
            "KEGG.db",                                  # AnnotationData
    ## >     "ReactomePA",                              # Pathways
    ## >     "STRINGdb",                                # Pathways
    ## >     "reactome.db",                             # AnnotationData

    ## Ribo-seq.

    ## Single-cell RNA-seq
            ## > "VeloViz" (submitted)

    ## Variation.
            "DNAcopy",                                  # CopyNumberVariation
            "VariantAnnotation",                        # Annotation

    ## These annotation/database packages are large, and not recommended to
    ## install on all machines by default.
    ## > .install(
            "targetscan.Hs.eg.db",                      # miRNA

    .install(
        pkgs = c(
            "ComplexHeatmap",                           # Visualization
            "ConsensusClusterPlus",                     # Visualization
            "DESeq2",                                   # RNASeq
            "DEXSeq",                                   # RNASeq
            "DiffBind",                                 # ChIPSeq
            "DropletUtils",                             # SingleCell
            "EDASeq",                                   # RNASeq
            "EnhancedVolcano",                          # Visualization
            "Gviz",                                     # Visualization
            "HDF5Array",                                # DataRepresentation
            "HSMMSingleCell",                           # SingleCell
            "IHW",                                      # RNASeq
            "KEGGREST",                                 # Pathways
            "KEGGgraph",                                # Visualization
            "MAST",                                     # RNASeq
            "MultiAssayExperiment",                     # DataRepresentation
            "PANTHER.db",                               # AnnotationData
            "RDAVIDWebService",                         # Pathways
            "Rhdf5lib",                                 # DataRepresentation
            "Rhtslib",                                  # DataRepresentation
            "RiboProfiling",                            # RiboSeq
            "Rsamtools",                                # Alignment
            "Rsubread",                                 # Alignment
            "SC3",                                      # SingleCell
            "ShortRead",                                # Alignment
            "SpidermiR",                                # miRNA
            "TCGAbiolinks",                             # Sequencing
            "apeglm",                                   # RNASeq
            "ballgown",                                 # RNASeq
            "batchelor",                                # SingleCell
            "beachmat",                                 # SingleCell
            "biobroom",                                 # DataImport

            "biovizBase",                               # Visualization
            "cBioPortalData",                           # RNASeq
            "cbaf",                                     # RNASeq
            "clusterExperiment",                        # SingleCell
            "csaw",                                     # ChIPSeq
            "destiny",                                  # SingleCell
            "edgeR",                                    # RNASeq
            "enrichR",                                  # Pathways
            "enrichplot",                               # Visualization
            "fgsea",                                    # Pathways
            "scDataviz",                                # SingleCell
            "fishpond",                                 # RNASeq
            "genefilter",                               # Microarray
            "geneplotter",                              # Visualization
            "ggbio",                                    # Visualization
            "ggtree",                                   # Visualization
            "gage",                                     # ???
            "goseq",                                    # Pathways
            "isomiRs",                                  # miRNA
            "limma",                                    # RNASeq
            "miRBaseConverter",                         # miRNA
            "miRNApath",                                # miRNA
            "miRNAtap",                                 # miRNA
            "mirbase.db",                               # miRNA/AnnotationData
            "multiMiR",                                 # miRNA
            "multtest",                                 # MultipleComparison
            "pathview",                                 # Pathways
            "pcaMethods",                               # Bayesian
            "rhdf5",                                    # DataRepresentation
            "riboSeqR",                                 # RiboSeq
            "scater",                                   # SingleCell
            "scone",                                    # SingleCell
            "scran",                                    # SingleCell
            "sctransform",                              # SingleCell
            "slalom",                                   # SingleCell
            "slingshot",                                # SingleCell
            "splatter",                                 # SingleCell
            "tximeta",                                  # RNASeq
            "tximport",                                 # RNASeq
            "vsn",                                      # Visualization
            "zinbwave"                                  # SingleCell
        )
    )
    message(okMsg)
}
