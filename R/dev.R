#' Load Developer Environment
#'
#' @return Invisible character vector of packages attached specifically by
#'   this function call.
#'
#' @export
#' @examples
#' \dontrun{
#' dev()
#' }
dev <- function() {
    deps <- desc_get_deps(find.package("bb8")[[1L]])
    packages <- deps %>%
        .[.[["type"]] != "Depends", , drop = FALSE] %>%
        .[["package"]]

    # Order of final packages to load is important
    final <- c(
        "tidyverse",
        "rlang",
        "assertive"
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
                suppressPackageStartupMessages(
                    attachNamespace(package)
                )
                package
            }
        })
    attached <- unlist(attached)

    # Check Bioconductor installation
    biocValid <- tryCatch(
        biocValid(silent = TRUE),
        error = function(e) {
            message("Bioconductor installation is not valid")
        }
    )

    # Show NAMESPACE conflicts
    show(tidyverse_conflicts())

    invisible(attached)
}
