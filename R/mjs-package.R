#' MJS devtools
#'
#' Personal package with additional devtools utilities.
#'
#' @import devtools
#'
#' @importFrom BiocCheck BiocCheck
#' @importFrom BiocInstaller biocValid
#' @importFrom covr package_coverage
#' @importFrom lintr lint_package
#' @importFrom magrittr %>%
#' @importFrom pkgdown build_site
#' @importFrom rmarkdown render
#' @importFrom testthat expect_equal
#' @importFrom tools file_path_sans_ext
#' @importFrom utils globalVariables
"_PACKAGE"

globalVariables(c(".", "biocLite"))
