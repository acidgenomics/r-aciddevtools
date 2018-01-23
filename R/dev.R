#' Load Developer Environment
#'
#' @importFrom BiocInstaller biocValid
#' @importFrom utils installed.packages
#'
#' @return No return.
#' @export
dev <- function() {
    # Order is important here
    packages <-
        c("jsonlite",
          "magrittr",
          "Matrix",
          "pbapply",
          "scales",
          "viridis",
          # Package development ================================================
          "devtools",
          "covr",
          "lintr",
          "testthat",
          # RStudio core =======================================================
          "googlesheets",
          "knitr",
          "pkgdown",
          "readxl",
          "rmarkdown",
          "stringr",
          # Final NAMESPACE bootup =============================================
          "Biobase",
          "BiocInstaller",
          "S4Vectors",
          "basejump",
          "tidyverse",
          "rlang")

    # Stop on missing packages
    notInstalled = setdiff(packages, rownames(installed.packages()))
    if (length(notInstalled) > 0) {
        stop(paste(
            "Not installed:",
            toString(notInstalled)
        ), call. = FALSE)
    }

    # Attach unloaded packages
    lapply(seq_along(packages), function(a) {
        if (!packages[[a]] %in% (.packages())) {
            attachNamespace(packages[[a]])
        }
    })
    invisible()

    # Check that workspace is kosher
    biocValid(silent = TRUE)
}
