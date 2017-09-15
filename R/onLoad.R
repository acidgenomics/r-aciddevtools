.onLoad <- function(libname, pkgname) {
    pkgs <-
        c("Matrix",
          "pbapply",
          "viridis",
          # Package development ====
          "devtools",
          "covr",
          "lintr",
          "testthat",
          # RStudio core ====
          "googlesheets",
          "pkgdown",
          "readxl",
          "rmarkdown",
          "stringr",
          # Final NAMESPACE bootup ====
          "Biobase",
          "basejump",
          "rlang",
          "tidyverse")
    lapply(seq_along(pkgs), function(a) {
        if (!pkgs[a] %in% (.packages())) {
            attachNamespace(pkgs[a])
        }
    })
    invisible()
}
