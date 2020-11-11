#' Current Bioconductor release version
#'
#' @export
#' @note Updated 2020-11-11.
#'
#' @return `package_version`.
#'
#' @seealso
#' - https://bioconductor.org/bioc-version
#' - https://bioconductor.org/config.yaml
#'
#' @examples
#' currentBiocVersion()
currentBiocVersion <- function() {
    url <- "https://bioconductor.org/bioc-version"
    x <- readLines(con = url, warn = FALSE)
    x <- package_version(x)
    x
}
