#' Update All Installed Packages
#'
#' Ensure that all [Bioconductor](https://bioconductor.org),
#' [CRAN](https://cran.r-project.org), and [GitHub](https://github.com) packages
#' are up to date.
#'
#' Internally, this is a wrapper for [devtools::update_packages()] that adds
#' Bioconductor support.
#'
#' @return Library validity check.
#' @export
updatePackages <- function() {
    # Update Bioconductor packages first.
    BiocManager::install()

    # Now update packages from GitHub repos.
    # `pkgs = TRUE` will update all packages without prompt.
    devtools::update_packages(pkgs = TRUE)

    # Ensure safe developer environment.
    BiocManager::valid()
}
