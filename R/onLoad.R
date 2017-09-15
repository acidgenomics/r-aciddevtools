.onLoad <- function(libname, pkgname) {
    pkgs <- c("pbapply",
              "viridis",
              "Matrix",
              "googlesheets",
              "readxl",
              "stringr",
              "rlang",
              "tidyverse")
    lapply(seq_along(pkgs), function(a) {
        if (!pkgs[a] %in% (.packages())) {
            attachNamespace(pkgs[a])
        }
    })
    invisible()
}
