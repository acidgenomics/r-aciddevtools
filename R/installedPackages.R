#' Find installed packages
#'
#' Includes "source" column, indicating whether package is from CRAN,
#' Bioconductor, or from a remote (i.e. GitHub, GitLab) install.
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @seealso
#' - `sessioninfo::package_info()`.
#' - `utils::installed.packages()`.
#'
#' @examples
#' x <- installedPackages()
#' table(x[["source"]])
installedPackages <- function() {
    stopifnot(
        requireNamespace("syntactic", quietly = TRUE),
        requireNamespace("utils", quietly = TRUE)
    )
    data <- as.data.frame(utils::installed.packages())
    colnames(data) <- syntactic::camelCase(colnames(data))
    pkgs <- data[["package"]]
    isAcid <- function(desc) {
        grepl("^https://.+\\.acidgenomics\\.com", desc[["URL"]])
    }
    isBioconductor <- function(desc) {
        grepl("^https://git\\.bioconductor\\.org", desc[["git_url"]])
    }
    isCRAN <- function(desc) {
        identical(desc[["Repository"]], "CRAN")
    }
    isGitHub <- function(desc) {
        identical(tolower(desc[["RemoteType"]]), "github")
    }
    isGitLab <- function(desc) {
        identical(tolower(desc[["RemoteType"]]), "gitlab")
    }
    source <- vapply(
        X = pkgs,
        FUN = function(pkg) {
            desc <- utils::packageDescription(pkg)
            if (isTRUE(isCRAN(desc))) {
                "CRAN"
            } else if (isTRUE(isGitHub(desc))) {
                "GitHub"
            } else if (isTRUE(isGitLab(desc))) {
                "GitLab"
            } else if (isTRUE(isBioconductor(desc))) {
                "Bioconductor"
            } else if (isTRUE(isAcid(desc))) {
                "Acid Genomics"
            } else {
                ## Using "local" instead of `NA_character_` matches the
                ## return of `sessioninfo::session_info()`.
                "local"
            }
        },
        FUN.VALUE = character(1L)
    )
    data[["source"]] <- as.factor(source)
    data
}
