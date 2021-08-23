#' Get current release version of package from GitHub
#'
#' @export
#' @note Updated 2021-08-23.
#'
#' @param repo `character`.
#'   GitHub repository ("user/package").
#'   Vectorized, supporting multiple requests in a single call.
#'
#' @return `package_version`.
#'   Package `repo` is defined in `names`.
#'
#' @examples
#' repo <- paste0("r-lib/", c("rlang", "testthat"))
#' print(repo)
#' x <- getCurrentGitHubVersion(repo)
#' print(x)
getCurrentGitHubVersion <- function(repo) {
    x <- vapply(
        X = repo,
        FUN = function(repo) {
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
            x
        },
        FUN.VALUE = character(1L),
        USE.NAMES = FALSE
    )
    x <- package_version(x)
    names(x) <- repo
    x
}
