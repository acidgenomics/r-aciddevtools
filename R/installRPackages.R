#' Install recommended default R packages
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
#' @note Updated 2020-11-03.
#'
#' @param all `logical(1)`.
#'   Install additional extra packages.
#'
#' @seealso
#' - https://www.bioconductor.org/packages/release/BiocViews.html#___Software
#'
#' @examples
#' ## > installRPackages()
installRPackages <- function(all = FALSE) {
    assert(isFlag(all))
    ## These dependencies are required to install sf, etc.
    assert(allAreSystemCommands(c("gdal-config", "geos-config")))
    ## Check for GitHub PAT, if necessary.
    if (isTRUE(all)) {
        assert(hasGitHubPAT())
    }
    installBioconductor()
    h1("Install R packages")
    h2("Tricky packages")
    ## > cranArchive <- "https://cloud.r-project.org/src/contrib/Archive/"
    ## > install(
    ## >     pkgs = c(
    ## >         paste0(cranArchive, "cpp11/cpp11_0.1.0.tar.gz"),
    ## >         paste0(cranArchive, "rgdal/rgdal_1.5-12.tar.gz"),
    ## >     ),
    ## >     reinstall = FALSE
    ## > )
    ## > if (isMacOS()) {
    ## >     binPrefix <- "https://cran.r-project.org/bin/macosx/contrib/4.0/"
    ## >     install(
    ## >         pkgs = paste0(binPrefix, "mgcv_1.8-32.tgz"),
    ## >         reinstall = FALSE
    ## >     )
    ## > }
    install(
        pkgs = c(
            "Rcpp",
            "RcppArmadillo",
            "RcppAnnoy",
            "XML",
            "rJava",
            "rgdal",
            "sf"
        ),
        reinstall = FALSE
    )
    h2("CRAN")
    install(
        pkgs = c(
            "DT",
            "Matrix",
            "R.utils",
            "Rcpp",
            "RcppArmadillo",
            "backports",
            "broom",
            "caTools",
            "cli",
            "covr",
            "cowplot",
            "curl",
            "data.table",
            "desc",
            "devtools",
            "ggrepel",
            "git2r",
            "httr",
            "knitr",
            "lintr",
            "lobstr",
            "magrittr",
            "matrixStats",
            "parallel",
            "patrick",
            "pbapply",
            "pkgdown",
            "processx",
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
            "usethis",
            "viridis",
            "vroom",
            "xmlparsedata"
        ),
        reinstall = FALSE
    )
    h2("Bioconductor")
    ## 2020-10-29: Temporary fix for missing packages in BioC 3.13 repo.
    ## > if (isTRUE(isBiocDevel())) {
    ## >     install(
    ## >         pkgs = paste0(
    ## >             "https://git.bioconductor.org/packages/",
    ## >             c(
    ## >                 "DelayedArray",
    ## >                 "SingleCellExperiment"
    ## >             )
    ## >         ),
    ## >         reinstall = FALSE
    ## >     )
    ## > }
    install(
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
        ),
        reinstall = FALSE
    )
    if (!isTRUE(all)) {
        return(invisible(NULL))
    }
    h1("Install additional R packages ({.arg --all} mode)")
    h2("CRAN")
    install(
        pkgs = c(
            "NMF",
            "R.oo",
            "R6",
            "Seurat",
            "UpSetR",
            "WGCNA",
            "ashr",
            "available",
            "bookdown",
            "cgdsr",  # cBioPortal
            "datapasta",
            "dbplyr",
            "dendextend",
            "dendsort",
            "dynamicTreeCut",
            "fastICA",
            "fastcluster",
            "fastmatch",
            "fdrtool",
            "fs",
            "future",
            "ggdendro",
            "ggpubr",
            "ggrepel",
            "ggridges",
            "ggupset",
            "gprofiler2",
            "hexbin",
            "htmlwidgets",
            "janitor",
            "jsonlite",
            "languageserver",
            "memoise",
            "openxlsx",
            "packrat",
            "pheatmap",
            "pillar",
            "plyr",
            "pryr",
            "ps",
            "pzfx",
            "rdrop2",
            "readxl",
            "reshape2",
            "rio",
            "shinycssloaders",
            "slam",
            "snakecase",
            "snow",
            "uwot",
            "waldo"
        ),
        reinstall = FALSE
    )
    h2("Bioconductor")
    install(
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
            "gage",                                     # Pathways
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
        ),
        reinstall = FALSE
    )
    h2("Acid Genomics")
    installAcidverse()
    h2("GitHub")
    install(
        pkgs = c(
            "BaderLab/scClustViz",                      # SingleCell
            "cole-trapnell-lab/monocle3",               # SingleCell
            "jonocarroll/DFplyr",                       # DataRepresentation
            "js229/Vennerable",                         # Visualization
            "kevinblighe/scDataviz",                    # SingleCell
            "waldronlab/cBioPortalData"                 # RNASeq
        ),
        reinstall = FALSE
    )
    message("Installation of R packages was successful.")
}
