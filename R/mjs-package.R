#' MJS devtools
#'
#' Personal package with additional devtools utilities.
#'
#' @import devtools
#'
#' @importFrom BiocCheck BiocCheck
#' @importFrom magrittr %>%
#' @importFrom readr read_csv
#' @importFrom rmarkdown render
#' @importFrom tools file_path_sans_ext
#' @importFrom utils globalVariables installed.packages
"_PACKAGE"

globalVariables(c(".", "biocLite"))
