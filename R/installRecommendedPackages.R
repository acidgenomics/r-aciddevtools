## NOTE "grid" package is getting duplicated on Ubuntu 22.

## Consider including these packages:
##
## CRAN:
## - MetBrewer
## - NMF
## - UpSetR
## - box
## - cowplot (now using patchwork instead)
## - datapasta
## - dr4pl
## - formatR (using styler instead)
## - fs
## - gdscDataViewR
## - git2r
## - glue
## - htmlwidgets
## - lifecycle
## - liger (for GSEA)
## - lobstr
## - packrat
## - pak
## - pillar
## - prettycode
## - prettyunits
## - ps
## - rdrop2
## - reticulate
## - rsconnect (for shinyapps.io)
## - servr
## - sessioninfo (sessionInfo replacement)
## - slam
## - sloop
## - snakecase
## - snow
## - spatialreg
## - waldo
## - xmlparsedata
##
## Bioc2022 recommendations:
## - dreamlet (Bioc 3.16; 2022-09 release)
## - netZooR
## - scChromHMM
## - variancePartition
##
## Bioconductor:
## - AnnotationFilter
## - BSgenome.Hsapiens.NCBI.GRCh38
## - BSgenome.Hsapiens.UCSC.hg19
## - BSgenome.Hsapiens.UCSC.hg38
## - BSgenome.Mmusculus.UCSC.mm10
## - BiocSet
## - DNAcopy
## - DelayedArray
## - DelayedMatrixStats
## - EDASeq
## - EnsDb.Hsapiens.v75 (GRCh37; hg19)
## - ExperimentHub
## - GEOquery
## - GOSemSim
## - GSEABase
## - GSVA
## - GenomicDistributions
## - HDF5Array
## - HSMMSingleCell
## - KEGG.db
## - KEGGREST
## - KEGGgraph
## - MultiAssayExperiment
## - RDAVIDWebService (removed in 3.14).
## - PANTHER.db
## - ReactomePA
## - Rhdf5lib
## - Rhtslib
## - RiboProfiling
## - SC3
## - ShortRead
## - SpidermiR
## - TCGAbiolinks
## - TargetScore
## - TxDb.Hsapiens.UCSC.hg19.knownGene
## - TxDb.Hsapiens.UCSC.hg38.knownGene
## - TxDb.Mmusculus.UCSC.mm10.knownGene
## - VariantAnnotation
## - airpart
## - ballgown
## - batchelor
## - beachmat
## - biobroom
## - biovizBase
## - cBioPortalData
## - cbaf (cBioPortal)
## - clusterExperiment
## - condiments
## - destiny
## - genefilter
## - geneplotter
## - goseq
## - isomiRs
## - memes
## - miRBaseConverter
## - miRNApath
## - miRNAtap
## - miloR
## - mirbase.db
## - moanin
## - multiMiR
## - org.Hs.eg.db
## - org.Mm.eg.db
## - reactome.db (very large)
## - rhdf5
## - riboSeqR
## - satuRn
## - scDataviz
## - scater
## - scone
## - scran
## - sctransform
## - slalom
## - slingshot
## - splatter
## - synergyfinder
## - targetscan.Hs.eg.db
## - zinbwave
##
## In development:
## - VeloViz
## - immunogenomics/scpost (power calculations)

#' Install recommended R packages
#'
#' @export
#' @note Updated 2023-03-10.
#'
#' @examples
#' ## > installRecommendedPackages()
installRecommendedPackages <-
    function() {
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
        pkgs <- character()
        ## Base R recommended packages.
        pkgs <- append(
            x = pkgs,
            values = c(
                "KernSmooth",
                "MASS",
                "Matrix",
                "boot",
                "class",
                "cluster",
                "codetools",
                "foreign",
                "lattice",
                "mgcv",
                "nlme",
                "nnet",
                "rpart",
                "spatial",
                "survival"
            )
        )
        ## These can be tricky to build.
        pkgs <- append(
            x = pkgs,
            values = c(
                "Rcpp",
                "RcppArmadillo",
                "RcppAnnoy",
                "XML",
                "rJava",
                "data.table"
            )
        )
        ## CRAN packages.
        pkgs <- append(
            x = pkgs,
            values = c(
                "DT",
                "GGally",
                "Matrix",
                "R.utils",
                "RSQLite",
                "Seurat",
                "WGCNA",
                "ashr",
                "backports",
                "bench",
                "bookdown",
                "broom",
                "cli",
                "conflicted",
                "covr",
                "crayon",
                "curl",
                "dbplyr",
                "dendextend",
                "dendsort",
                "desc",
                "devtools",
                "drat",
                "dynamicTreeCut",
                "enrichR",
                "fastICA",
                "fastcluster",
                "fastmatch",
                "fdrtool",
                "furrr",
                "future",
                "ggdendro",
                "ggpubr",
                "ggrepel",
                "ggrepel",
                "ggridges",
                "ggstatsplot",
                "ggupset",
                "gprofiler2",
                "hexbin",
                "httpgd",
                "import",
                "janitor",
                "jsonlite",
                "knitr",
                "languageserver",
                "lintr",
                "magick",
                "magrittr",
                "matrixStats",
                "memoise",
                "ontologyIndex",
                "openxlsx",
                "patchwork",
                "pheatmap",
                "pkgdown",
                "processx",
                "profvis",
                "pvclust",
                "pzfx",
                "ragg",
                "rcmdcheck",
                "remotes",
                "reprex",
                "rio",
                "rlang",
                "rmarkdown",
                "roxygen2",
                "shiny",
                "shinycssloaders",
                "shinydashboard",
                "stringi",
                "styler",
                "testthat",
                "tidytext",
                "tidyverse",
                "uniqtag",
                "usethis",
                "uwot",
                "viridis",
                "vroom",
                "withr"
            )
        )
        ## Bioconductor packages.
        pkgs <- append(
            x = pkgs,
            values = c(
                "AnnotationDbi",
                "AnnotationHub",
                "Biobase",
                "BiocCheck",
                "BiocFileCache",
                "BiocGenerics",
                "BiocParallel",
                "BiocStyle",
                "Biostrings",
                "ChIPpeakAnno",
                "ComplexHeatmap",
                "ConsensusClusterPlus",
                "DESeq2",
                "DEXSeq",
                "DOSE",
                "DiffBind",
                "DropletUtils",
                "EnhancedVolcano",
                "GRmetrics",
                "GenomeInfoDb",
                "GenomeInfoDbData",
                "GenomicAlignments",
                "GenomicFeatures",
                "GenomicRanges",
                "Gviz",
                "IHW",
                "IRanges",
                "InteractiveComplexHeatmap",
                "MAST",
                "Rsamtools",
                "Rsubread",
                "S4Vectors",
                "STRINGdb",
                "SingleCellExperiment",
                "SummarizedExperiment",
                "apeglm",
                "biomaRt",
                "clusterProfiler",
                "csaw",
                "edgeR",
                "enrichplot",
                "ensembldb",
                "fgsea",
                "fishpond",
                "gage",
                "ggbio",
                "ggtree",
                "limma",
                "multtest",
                "pathview",
                "pcaMethods",
                "plotgardener",
                "rtracklayer",
                "tximeta",
                "tximport",
                "vsn"
            )
        )
        install(pkgs = pkgs, dependencies = NA, reinstall = FALSE)
        installAcidverse()
        invisible(TRUE)
    }
