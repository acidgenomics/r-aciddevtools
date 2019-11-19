#' Get current version of package from GitHub
#'
#' @export
#' @note Updated 2019-11-19.
#'
#' @param repo `character(1)`.
#'   GitHub repository ("user/package").
#'
#' @examples
#' getCurrentVersion(repo = "acidgenomics/bb8")
getCurrentVersion <- function(repo) {
    url <- paste0("https://github.com/", repo, "/releases/latest")
    x <- readLines(url)
    x <- grep(
        pattern = "v[.0-9]+.tar.gz",
        x = x,
        value = TRUE
    )
    x <- gsub(
        pattern = "^.+\\bv([.0-9]+).tar.gz\\b.+$",
        replacement = "\\1",
        x = x
    )
    x <- package_version(x)
    x
}
