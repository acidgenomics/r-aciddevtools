#' Install recommended R packages
#'
#' @section Tricky packages:
#'
#' - **2020-08-24**: mgcv v1.8-32 won't build on macOS due to `_kij` missing.
#'   Can fix by installing binary package instead.
#'   This issue is fixed in v1.8-33, on CRAN 2020-08-27.
#' - **2020-08-05**: rgdal v1.5-15 won't build on Debian.
#'   Fixed with v1.5-16.
#' - **2020-08-11**: cpp11 v0.2.0 update is breaking tidyr.
#'   See https://github.com/tidyverse/tidyr/issues/1024 for details.
#'
#' @export
#' @note Updated 2021-01-18.
#'
#' @param all `logical(1)`.
#'   Install additional extra packages.
#'
#' @seealso
#' - https://www.bioconductor.org/packages/release/BiocViews.html#___Software
#'
#' @examples
#' ## > installRecommendedPackages()
installRecommendedPackages <- function(all = TRUE) {
    stopifnot(is.logical(all) && length(all) == 1L)
    .install <- function(...) {
        install(..., reinstall = FALSE)
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
    ## Tricky packages =========================================================
    ## > cranArchive <- "https://cloud.r-project.org/src/contrib/Archive/"
    ## > .install(
    ## >     pkgs = c(
    ## >         paste0(cranArchive, "cpp11/cpp11_0.1.0.tar.gz"),
    ## >         paste0(cranArchive, "rgdal/rgdal_1.5-12.tar.gz"),
    ## >     )
    ## > )
    ## > if (isMacOS()) {
    ## >     binPrefix <- "https://cran.r-project.org/bin/macosx/contrib/4.0/"
    ## >     .install(
    ## >         pkgs = paste0(binPrefix, "mgcv_1.8-32.tgz")
    ## >     )
    ## > }
    .install(
        pkgs = c(
            "Rcpp",
            "RcppArmadillo",
            "RcppAnnoy",
            "XML",
            "rJava",
            "rgdal",
            "sf"
        )
    )
    ## CRAN (default) ==========================================================
    .install(
        pkgs = c(
            "Matrix",
            "R.utils",
            "Rcpp",
            "RcppArmadillo",
            "bench",
            "covr",
            "cowplot",
            "curl",
            "data.table",
            "desc",
            "devtools",
            "ggrepel",
            "httr",
            "knitr",
            "lintr",
            "magrittr",
            "matrixStats",
            "parallel",
            "pkgdown",
            "profvis",
            "rcmdcheck",
            "remotes",
            "reprex",
            "reticulate",
            "rlang",
            "rmarkdown",
            "roxygen2",
            "sessioninfo",
            "shiny",
            "shinydashboard",
            "sloop",
            "stringi",
            "testthat",
            "tidyverse",
            "viridis",
            "vroom"
        )
    )
    ## Bioconductor (default) ==================================================
    ## 2020-10-29: Temporary fix for missing packages in BioC 3.13 repo.
    ## > if (isTRUE(isBiocDevel())) {
    ## >     .install(
    ## >         pkgs = paste0(
    ## >             "https://git.bioconductor.org/packages/",
    ## >             c(
    ## >                 "DelayedArray",
    ## >                 "SingleCellExperiment"
    ## >             )
    ## >         )
    ## >     )
    ## > }
    .install(
        pkgs = c(
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
            "DelayedArray",
            "DelayedMatrixStats",
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
    )
    if (!isTRUE(all)) {
        message(okMsg)
        return(invisible(NULL))
    }
    ## Acid Genomics ===========================================================
    installAcidverse()
    ## CRAN (extra) ============================================================
    .install(
        pkgs = c(
            ## > "Seurat",  # dependency issue
            ## > "available",
            ## > "dendsort",  # dependency issue
            "DT",
            "NMF",
            "R.oo",
            "R6",
            "UpSetR",
            "WGCNA",
            "ashr",
            "backports",
            "bookdown",
            "broom",
            "cgdsr",  # cBioPortal
            "cli",
            "crayon",
            "datapasta",
            "dbplyr",
            "dendextend",
            "drat",
            "dynamicTreeCut",
            "fastICA",
            "fastcluster",
            "fastmatch",
            "fdrtool",
            "forcats",
            "fs",
            "future",
            "ggdendro",
            "ggpubr",
            "ggrepel",
            "ggridges",
            "ggupset",
            "git2r",
            "glue",
            "gprofiler2",
            "hexbin",
            "htmlwidgets",
            "janitor",
            "jsonlite",
            "languageserver",
            "lobstr",
            "lubridate",
            "memoise",
            "openxlsx",
            "packrat",
            "pbapply",
            "pheatmap",
            "pillar",
            "plyr",
            "prettyunits",
            "processx",
            "pryr",
            "ps",
            "pzfx",
            "rdrop2",
            "readxl",
            "reshape2",
            "rio",
            "rvest",
            "shinycssloaders",
            "slam",
            "snakecase",
            "snow",
            "styler",  # kind of like Python black for R
            "tidytext",
            "usethis",
            "uwot",
            "waldo",
            "xmlparsedata"
        )
    )
    ## Bioconductor ============================================================
    .install(
        pkgs = c(
            ## > "BSgenome.Hsapiens.NCBI.GRCh38",       # AnnotationData
            ## > "BSgenome.Hsapiens.UCSC.hg19",         # AnnotationData
            ## > "BSgenome.Hsapiens.UCSC.hg38",         # AnnotaitonData
            ## > "BSgenome.Mmusculus.UCSC.mm10",        # AnnotationData
            ## > "ReactomePA",                          # Pathways
            ## > "reactome.db",                         # AnnotationData
            ## > "STRINGdb",                            # Pathways
            "AnnotationFilter",                         # Annotation
            "ChIPpeakAnno",                             # ChIPSeq
            "ComplexHeatmap",                           # Visualization
            "ConsensusClusterPlus",                     # Visualization
            "DESeq2",                                   # RNASeq
            "DEXSeq",                                   # RNASeq
            "DNAcopy",                                  # CopyNumberVariation
            "DOSE",                                     # Pathways
            "DiffBind",                                 # ChIPSeq
            "DropletUtils",                             # SingleCell
            "EDASeq",                                   # RNASeq
            "EnhancedVolcano",                          # Visualization
            "EnsDb.Hsapiens.v75",                       # AnnotationData
            "EnsDb.Hsapiens.v86",                       # AnnotationData
            "ExperimentHub",                            # Annotation
            "GEOquery",                                 # Annotation
            "GOSemSim",                                 # Pathways
            "GSEABase",                                 # Pathways
            "GSVA",                                     # Pathways
            "Gviz",                                     # Visualization
            "HDF5Array",                                # DataRepresentation
            "HSMMSingleCell",                           # SingleCell
            "IHW",                                      # RNASeq
            "KEGG.db",                                  # AnnotationData
            "KEGGREST",                                 # Pathways
            "KEGGgraph",                                # Visualization
            "MAST",                                     # RNASeq
            "MultiAssayExperiment",                     # DataRepresentation
            "PANTHER.db",                               # AnnotationData
            "RDAVIDWebService",                         # Pathways
            "Rhdf5lib",                                 # DataRepresentation
            "Rhtslib",                                  # DataRepresentation
            "Rsamtools",                                # Alignment
            "Rsubread",                                 # Alignment
            "SC3",                                      # SingleCell
            "ShortRead",                                # Alignment
            "SpidermiR",                                # miRNA
            "TCGAbiolinks",                             # Sequencing
            "TargetScore",                              # miRNA
            "TxDb.Hsapiens.UCSC.hg19.knownGene",        # AnnotationData
            "TxDb.Hsapiens.UCSC.hg38.knownGene",        # AnnotationData
            "TxDb.Mmusculus.UCSC.mm10.knownGene",       # AnnotationData
            "VariantAnnotation",                        # Annotation
            "apeglm",                                   # RNASeq
            "ballgown",                                 # RNASeq
            "batchelor",                                # SingleCell
            "beachmat",                                 # SingleCell
            "biobroom",                                 # DataImport
            "biomaRt",                                  # Annotation
            "biovizBase",                               # Visualization
            "cBioPortalData",                           # RNASeq
            "cbaf",                                     # RNASeq
            "clusterProfiler",                          # Pathways
            "csaw",                                     # ChIPSeq
            "destiny",                                  # SingleCell
            "edgeR",                                    # RNASeq
            "enrichplot",                               # Visualization
            "fgsea",                                    # Pathways
            "fishpond",                                 # RNASeq
            "genefilter",                               # Microarray
            "geneplotter",                              # Visualization
            "ggbio",                                    # Visualization
            "ggtree",                                   # Visualization
            "goseq",                                    # Pathways
            "isomiRs",                                  # miRNA
            "limma",                                    # RNASeq
            "miRBaseConverter",                         # miRNA
            "miRNApath",                                # miRNA
            "miRNAtap",                                 # miRNA
            "mirbase.db",                               # AnnotationData
            "multiMiR",                                 # miRNA
            "multtest",                                 # MultipleComparison
            "org.Hs.eg.db",                             # AnnotationData
            "org.Mm.eg.db",                             # AnnotationData
            "pathview",                                 # Pathways
            "pcaMethods",                               # Bayesian
            "rhdf5",                                    # DataRepresentation
            "scater",                                   # SingleCell
            "scone",                                    # SingleCell
            "scran",                                    # SingleCell
            "sctransform",                              # SingleCell
            "slalom",                                   # SingleCell
            "splatter",                                 # SingleCell
            "targetscan.Hs.eg.db",                      # miRNA
            "tximeta",                                  # RNASeq
            "tximport",                                 # RNASeq
            "vsn",                                      # Visualization
            "zinbwave"                                  # SingleCell
        )
    )
    ## GitHub ==================================================================
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    if (isTRUE(goalie::hasGitHubPAT())) {
        .install(
            pkgs = c(
                "BaderLab/scClustViz",                  # SingleCell
                "cole-trapnell-lab/monocle3",           # SingleCell
                "jonocarroll/DFplyr",                   # DataRepresentation
                "js229/Vennerable",                     # Visualization
                "kevinblighe/scDataviz",                # SingleCell
                "mojaveazure/loomR",                    # SingleCell
                "waldronlab/cBioPortalData"             # RNASeq
            )
        )
    }
    ## Packages with dependency issues =========================================
    install(
        pkgs = c(
            "dendsort",  # gapmap removed from CRAN.
            "gage",  # DESeq is deprecated from Bioconductor.
            "Seurat"  # loomR isn't on CRAN.
        ),
        dependencies = FALSE,
        reinstall = FALSE
    )
    message(okMsg)
}
