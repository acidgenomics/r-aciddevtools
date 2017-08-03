#' devtoolsMJS
#'
#' Personal package with additional devtools utilities.
#'
#' @importFrom BiocCheck BiocCheck
#' @importFrom BiocInstaller biocValid
#' @importFrom covr package_coverage
#' @importFrom devtools build build_vignettes check document install load_all
#'   test update_packages use_data use_data_raw use_testthat
#' @importFrom lintr lint_package
#' @importFrom magrittr %>%
#' @importFrom pkgdown build_site
#' @importFrom rmarkdown render
#' @importFrom utils globalVariables
"_PACKAGE"

globalVariables(c(".", "biocLite"))
