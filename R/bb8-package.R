#' bb8
#'
#' Trusty Sidekick for R Package Development
#'
#' @importFrom BiocCheck BiocCheck
#' @importFrom BiocInstaller biocValid
#' @importFrom desc desc_get_deps
#' @importFrom devtools build build_vignettes document install load_all
#'   update_packages
#' @importFrom methods show
#' @importFrom readr read_csv
#' @importFrom rmarkdown render
#' @importFrom tidyverse tidyverse_conflicts
#' @importFrom tools file_path_sans_ext
#' @importFrom utils globalVariables installed.packages View
"_PACKAGE"

globalVariables(c(".", "biocLite"))
