#' Load Developer Environment
#'
#' @importFrom BiocInstaller biocValid
#' @importFrom desc desc_get_deps
#' @importFrom utils installed.packages
#'
#' @return Invisible character vector of packages attached specifically by
#'   this function call.
#' @export
dev <- function() {
    deps <- desc_get_deps(find.package("bb8")[[1L]])
    packages <- deps %>%
        .[.[["type"]] != "Depends", , drop = FALSE] %>%
        .[["package"]]

    # Order of final packages to load is important
    final <- c(
        "Biobase",
        "BiocInstaller",
        "S4Vectors",
        "basejump",
        "rlang",
        "tidyverse"
    )

    packages <- c(setdiff(packages, final), final)

    # Stop on missing packages
    notInstalled <- setdiff(packages, rownames(installed.packages()))
    if (length(notInstalled) > 0) {
        stop(paste("Not installed:", toString(notInstalled)), call. = FALSE)
    }

    # Attach unloaded packages
    attached <- lapply(
        X = packages,
        FUN = function(package) {
            if (!package %in% (.packages())) {
                attachNamespace(package)
                package
            }
        })
    attached <- unlist(attached)

    # Check that workspace is kosher
    biocValid(silent = TRUE)

    invisible(attached)
}
