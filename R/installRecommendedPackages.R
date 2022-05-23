## nocov start



#' Install recommended R packages
#'
#' @export
#' @note Updated 2022-04-15.
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
#' Named logical vector of which types of extra packages to install.
#' Alternatively, can install all extra packages by setting to `TRUE`, or
#' disable the installation of any extra packages by setting to `FALSE`.
#'
#' @examples
#' ## > installRecommendedPackages()
installRecommendedPackages <-
    function(extra = c(
                 "acidverse" = TRUE,
                 "alignment" = FALSE,
                 "annotation" = FALSE,
                 "cancer" = FALSE,
                 "chipseq" = FALSE,
                 "devtools" = TRUE,
                 "enrichment" = FALSE,
                 "filesystem" = TRUE,
                 "general" = TRUE,
                 "graphics" = TRUE,
                 "pharma" = TRUE,
                 "riboseq" = FALSE,
                 "rnaseq" = FALSE,
                 "shiny" = TRUE,
                 "singlecell" = FALSE,
                 "smallrna" = FALSE,
                 "statistics" = FALSE,
                 "tidyverse" = TRUE,
                 "variation" = FALSE
             )) {
        stopifnot(is.logical(extra))
        .install <-
            function(
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
        ## Default packages =============================================== {{{1
        pkgs <- character()
        ## Tricky to build ------------------------------------------------ {{{2
        ## Order is important here.
        pkgs <- c(
            pkgs,
            "Rcpp",
            "RcppArmadillo",
            "RcppAnnoy",
            "XML",
            "rJava"
        )
        ## CRAN ----------------------------------------------------------- {{{2
        pkgs <- c(
            pkgs,
            "Matrix",
            "R.utils",
            "data.table",
            "future",
            "knitr",
            "magrittr",
            "matrixStats",
            "reticulate",
            "rmarkdown",
            "sessioninfo",
            "stringi",
            "viridis"
        )
        ## Bioconductor --------------------------------------------------- {{{2
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
            "SummarizedExperiment",
            "XVector",
            "ensembldb",
            "rtracklayer",
            "zlibbioc"
        )
        .install(pkgs)
        if (!any(extra)) {
            message(okMsg)
            return(invisible(TRUE))
        }
        ## Extra packages ================================================= {{{1
        pkgs <- character()
        ## Acid Genomics -------------------------------------------------- {{{2
        if (isTRUE(extra[["acidverse"]])) {
            installAcidverse()
        }
        ## CRAN ----------------------------------------------------------- {{{2
        if (isTRUE(extra[["tidyverse"]])) {
            pkgs <- c(pkgs, "tidyverse")
        }
        if (isTRUE(extra[["general"]])) {
            pkgs <- c(
                pkgs,
                "DT",
                "languageserver", # lsp (for vscode, nvim)
                "slam",
                "tidytext"
            )
        }
        if (isTRUE(extra[["annotation"]])) {
            pkgs <- c(
                pkgs,
                "ontologyIndex"
            )
        }
        if (isTRUE(extra[["cancer"]])) {
            ## Consider:
            ## t - cancerrxgene gdscIC50
            pkgs <- c(
                pkgs,
                "cgdsr" # cBioPortal
            )
        }
        if (isTRUE(extra[["devtools"]])) {
            ## Consider:
            ## - milesmcbain rmdocs
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
                "formatR",
                "furrr",
                "git2r",
                "glue",
                "lifecycle",
                "lintr",
                "lobstr",
                "memoise",
                "packrat",
                "pak",
                "pillar",
                "pkgdown",
                "prettycode",
                "processx",
                "profvis",
                "ps",
                "rcmdcheck",
                "remotes",
                "reprex",
                "rlang",
                "roxygen2",
                "servr",
                "sloop",
                "snow",
                "styler",
                "testthat",
                "usethis",
                "waldo",
                "withr",
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
                "ComplexUpset",
                "GGally",
                "MetBrewer",
                "UpSetR",
                "cowplot",
                "dendextend",
                "dendsort",
                "ggdendro",
                "ggpubr",
                "ggrepel",
                "ggrepel",
                "ggridges",
                "ggstatsplot",
                "ggupset",
                "hexbin",
                "magick",
                "patchwork",
                "pheatmap",
                "prettyunits",
                "ragg"
            )
        }
        if (isTRUE(extra[["pharma"]])) {
            pkgs <- c(
                pkgs,
                "dr4pl"
            )
        }
        if (isTRUE(extra[["shiny"]])) {
            ## Consider:
            ## - CancerRxGene gdscDataViewR
            pkgs <- c(
                pkgs,
                "InteractiveComplexHeatmap",
                "htmlwidgets",
                "rsconnect", # shinyapps.io
                "shiny",
                "shinycssloaders",
                "shinydashboard"
            )
        }
        if (isTRUE(extra[["singlecell"]])) {
            pkgs <- c(
                pkgs,
                "Seurat"
            )
        }
        if (isTRUE(extra[["statistics"]])) {
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
                "pvclust",
                "spatialreg", # spdep
                "uwot"
            )
        }
        ## Bioconductor --------------------------------------------------- {{{2
        ## New packages in 3.13 worth a look:
        ## (from https://twitter.com/mikelove/status/1395615161260650497)
        ## - GenomicDistributions
        ## - airpart
        ## - condiments
        ## - memes
        ## - miloR
        ## - moanin
        ## - satuRn
        if (isTRUE(extra[["general"]])) {
            pkgs <- c(
                pkgs,
                "DelayedArray",
                "DelayedMatrixStats",
                "HDF5Array",
                "MultiAssayExperiment",
                "Rhdf5lib",
                "Rhtslib",
                "rhdf5"
            )
        }
        if (isTRUE(extra[["alignment"]])) {
            pkgs <- c(
                pkgs,
                "Rsamtools",
                "Rsubread",
                "ShortRead"
            )
        }
        if (isTRUE(extra[["annotation"]])) {
            pkgs <- c(
                pkgs,
                "AnnotationFilter",
                ## > "BiocSet",
                "BSgenome.Hsapiens.NCBI.GRCh38",
                "BSgenome.Hsapiens.UCSC.hg19",
                "BSgenome.Hsapiens.UCSC.hg38",
                "BSgenome.Mmusculus.UCSC.mm10",
                "EnsDb.Hsapiens.v75", # GRCh37 (hg19)
                "ExperimentHub",
                "GEOquery",
                "TxDb.Hsapiens.UCSC.hg19.knownGene",
                "TxDb.Hsapiens.UCSC.hg38.knownGene",
                "TxDb.Mmusculus.UCSC.mm10.knownGene",
                "biomaRt",
                "org.Hs.eg.db",
                "org.Mm.eg.db"
            )
        }
        if (isTRUE(extra[["cancer"]])) {
            pkgs <- c(
                pkgs,
                "TCGAbiolinks",
                "cBioPortalData",
                "cbaf", # cBioPortal
                "synergyfinder"
            )
        }
        if (isTRUE(extra[["chipseq"]])) {
            pkgs <- c(
                pkgs,
                "ChIPpeakAnno",
                "DiffBind",
                "csaw"
            )
        }
        if (isTRUE(extra[["enrichment"]])) {
            ## Consider:
            ## - reactome.db (very large)
            pkgs <- c(
                pkgs,
                "DOSE",
                "GOSemSim",
                "GSEABase",
                "GSVA",
                "KEGG.db",
                "KEGGREST",
                "KEGGgraph",
                "PANTHER.db",
                "RDAVIDWebService",
                "ReactomePA",
                "STRINGdb",
                "clusterProfiler",
                "enrichR",
                "enrichplot",
                "fgsea",
                "gage",
                "goseq",
                "pathview"
            )
        }
        if (isTRUE(extra[["graphics"]])) {
            pkgs <- c(
                pkgs,
                "ComplexHeatmap",
                "ConsensusClusterPlus",
                "EnhancedVolcano",
                "Gviz",
                "biovizBase",
                "genefilter",
                "geneplotter",
                "ggbio",
                "ggtree",
                "plotgardener",
                "vsn"
            )
        }
        if (isTRUE(extra[["filesystem"]])) {
            pkgs <- c(
                pkgs,
                "biobroom"
            )
        }
        if (isTRUE(extra[["pharma"]])) {
            pkgs <- c(
                pkgs,
                "GRmetrics"
            )
        }
        if (isTRUE(extra[["riboseq"]])) {
            pkgs <- c(
                pkgs,
                "RiboProfiling",
                "riboSeqR"
            )
        }
        if (isTRUE(extra[["rnaseq"]])) {
            pkgs <- c(
                pkgs,
                "DESeq2",
                "DEXSeq",
                "EDASeq",
                "ballgown",
                "edgeR",
                "fishpond",
                "limma",
                "tximeta",
                "tximport"
            )
        }
        if (isTRUE(extra[["smallrna"]])) {
            pkgs <- c(
                pkgs,
                "SpidermiR",
                "TargetScore",
                "isomiRs",
                "miRBaseConverter",
                "miRNApath",
                "miRNAtap",
                "mirbase.db",
                "multiMiR",
                "targetscan.Hs.eg.db"
            )
        }
        if (isTRUE(extra[["singlecell"]])) {
            ## Consider:
            ## - VeloViz (submitted)
            ## - immunogenomics / scpost (power calculations)
            pkgs <- c(
                pkgs,
                "DropletUtils",
                "HSMMSingleCell",
                "MAST",
                "SC3",
                "SingleCellExperiment",
                "batchelor",
                "beachmat",
                "clusterExperiment",
                "destiny",
                "scDataviz",
                "scater",
                "scone",
                "scran",
                "sctransform",
                "slalom",
                "slingshot",
                "splatter",
                "zinbwave"
            )
        }
        if (isTRUE(extra[["statistics"]])) {
            pkgs <- c(
                pkgs,
                "IHW",
                "apeglm",
                "multtest",
                "pcaMethods"
            )
        }
        if (isTRUE(extra[["variation"]])) {
            pkgs <- c(
                pkgs,
                "DNAcopy",
                "VariantAnnotation"
            )
        }
        .install(pkgs)
        message(okMsg)
        invisible(TRUE)
    }



## nocov end
