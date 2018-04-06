#' Update All Installed Packages
#'
#' Ensure that all [Bioconductor](https://bioconductor.org),
#' [CRAN](https://cran.r-project.org), and [GitHub](https://github.com) packages
#' are up to date.
#'
#' Internaly this is a wrapper for [devtools::update_packages()] that adds
#' Bioconductor support.
#'
#' @export
#' @return No value.
updatePackages <- function() {
    # Update Bioconductor packages first
    biocLite()

    # Now update packages from GitHub repos
    # `pkgs = TRUE` will update all packages without prompt
    update_packages(pkgs = TRUE)

    # Ensure safe developer environment
    biocValid()
}
