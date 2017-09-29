#' Load up developer environment
#' @export
dev <- function() {
    # Order is important here
    pkgs <-
        c("magrittr",
          "Matrix",
          "pbapply",
          "viridis",
          # Package development ====
          "devtools",
          "covr",
          "lintr",
          "testthat",
          # RStudio core ====
          "googlesheets",
          "knitr",
          "pkgdown",
          "readxl",
          "rmarkdown",
          "stringr",
          # Final NAMESPACE bootup ====
          "Biobase",
          "BiocInstaller",
          "S4Vectors",
          "basejump",
          "tidyverse",
          "rlang")
    lapply(seq_along(pkgs), function(a) {
        if (!pkgs[[a]] %in% (.packages())) {
            attachNamespace(pkgs[[a]])
        }
    })
    invisible()
}
