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
    deps <- find.package("bb8") %>%
        desc_get_deps() %>%
        .[["package"]] %>%
        setdiff("R")

    # Order of final deps to load is important
    final <- c(
        "Matrix",
        "tidyverse",
        "rlang",
        "assertive"
    )
    deps <- c(setdiff(deps, final), final)

    # Stop on missing deps
    notInstalled <- setdiff(deps, rownames(installed.packages()))
    if (length(notInstalled) > 0) {
        stop(paste("Not installed:", toString(notInstalled)), call. = FALSE)
    }

    # Attach unloaded deps
    attached <- lapply(
        X = deps,
        FUN = function(dep) {
            if (!dep %in% (.packages())) {
                suppressPackageStartupMessages(
                    attachNamespace(dep)
                )
                dep
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
