#' Get current release version of package from GitHub
#'
#' @export
#' @note Updated 2021-08-23.
#'
#' @param repo `character`.
#' GitHub repository ("user/package").
#' Vectorized, supporting multiple requests in a single call.
#'
#' @return `package_version`.
#' Package `repo` is defined in `names`.
#'
#' @examples
#' repo <- paste("r-lib", c("rlang", "testthat"), sep = "/")
#' print(repo)
#' x <- getCurrentGitHubVersion(repo)
#' print(x)
getCurrentGitHubVersion <- function(repo) {
    stopifnot(requireNamespace("pipette", quietly = TRUE))
    x <- vapply(
        X = repo,
        FUN = function(repo) {
            url <- paste(
                "https://api.github.com", "repos", repo, "releases", "latest",
                sep = "/"
            )
            nullcon <- file(nullfile(), open = "wb")
            sink(nullcon, type = "message")
            suppressMessages({
                x <- pipette::import(url, format = "json", quiet = TRUE)
            })
            sink(type = "message")
            close(nullcon)
            x <- x[["tag_name"]]
            x <- gsub(pattern = "^v", replacement = "", x = x)
            x
        },
        FUN.VALUE = character(1L),
        USE.NAMES = FALSE
    )
    x <- package_version(x)
    names(x) <- repo
    x
}
