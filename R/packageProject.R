#' Package Project and Build Website
#'
#' @importFrom devtools build build_vignettes document install load_all
#'
#' @param install Install package.
#'
#' @export
packageProject <- function(install = FALSE) {
    # Ensure package is up to date
    document()
    build_vignettes()
    load_all()

    # Run integrity checks
    check()

    # Save the package build to disk
    build()

    # Install the package
    if (isTRUE(install)) {
        install()
    }
}
