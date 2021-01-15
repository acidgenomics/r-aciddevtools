#' Find installed packages
#'
#' Includes "source" column, indicating whether package is from CRAN,
#' Bioconductor, or from a remote (i.e. GitHub, GitLab) install.
#'
#' @export
#' @note Updated 2020-08-18.
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
    colnames(data) <- syntactic::camelCase(colnames(data), strict = TRUE)
    pkgs <- data[["package"]]
    isAcid <- function(desc) {
        grepl("^https://.+\\.acidgenomics\\.com", desc[["URL"]])
    }
    isBioconductor <- function(desc) {
        ok <- grepl(
            pattern = "^https://git\\.bioconductor\\.org",
            x = desc[["git_url"]]
        )
        if (isTRUE(ok)) return(TRUE)
        ok <- !is.null(desc[["biocViews"]])
        if (isTRUE(ok)) return(TRUE)
        FALSE
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
            if (!is.null(desc[["Repository"]])) {
                desc[["Repository"]]
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
