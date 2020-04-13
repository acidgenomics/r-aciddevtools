## Passing tar.gz release file from GitHub (`tarball_url` key) currently results
## in untar2 "skipping pax global extended headers" warning in
## `install.packages()` call below. Note that use of `zipball_url` doesn't work
## well, resulting in `rawToChar` embedded nul error.



#' Install packages from GitHub
#'
#' @details
#' This variant doesn't require `GITHUB_PAT`.
#' If you have a `GITHUB_PAT` defined, can use [install()] directly instead.
#' Intended for use inside container images, where a PAT may not be used.
#'
#' @section GitHub API:
#'
#' - All releases JSON:
#'   `https://api.github.com/repos/:owner/:repo/releases`
#' - Latest release JSON:
#'   `https://api.github.com/repos/:owner/:repo/releases/latest`
#' - Specific release JSON (requires numeric release ID, not tag name):
#'   `https://api.github.com/repos/:owner/:repo/releases/:release_id`
#' - Specific tagged release tarball:
#'   `https://github.com/:owner/:repo/archive/:tag.tar.gz`
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @inheritParams params
#' @param repo `character`.
#'   Repository address(es) in the format `owner/repo`.
#' @param release `character`.
#'   Release version tag.
#'   Defaults to latest version available.
#'   Specific release must match the tag on GitHub (e.g. "v1.0.0").
#'
#' @return Invisible `character`.
#'   Repository address defined in `repo` argument.
#'
#' @seealso
#' - `remotes::install_github`.
#' - `install.packages`.
#'
#' @examples
#' ## Install latest release, if necessary.
#' ## > installGitHub(
#' ## >     repo = c(
#' ## >         "acidgenomics/acidbase",
#' ## >         "acidgenomics/goalie"
#' ## >     ),
#' ## >     release = "latest",
#' ## >     reinstall = FALSE
#' ## > )
#'
#' ## Force reinstallation of specific versions.
#' ## > installGitHub(
#' ## >     repo = c(
#' ## >         "acidgenomics/acidbase",
#' ## >         "acidgenomics/goalie"
#' ## >     ),
#' ## >     release = c(
#' ## >         "v0.1.7",
#' ## >         "v0.4.4"
#' ## >     ),
#' ## >     reinstall = TRUE
#' ## > )
installGitHub <- function(
    repo,
    release = "latest",
    reinstall = FALSE
) {
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        all(grepl(x = repo, pattern = "^[^/]+/[^/]+$")),
        is.character(release) && identical(length(release), 1L),
        is.logical(reinstall) && identical(length(reinstall), 1L)
    )
    if (length(repo) > 1L && identical(release, "latest")) {
        release <- rep(release, times = length(repo))
    }
    stopifnot(identical(length(repo), length(release)))
    out <- mapply(
        repo = repo,
        release = release,
        MoreArgs = list(reinstall = reinstall),
        FUN = function(repo, release, reinstall) {
            ## > owner <- dirname(repo)
            pkg <- basename(repo)
            if (
                !isTRUE(reinstall) &&
                isTRUE(pkg %in% rownames(utils::installed.packages()))
            ) {
                message(sprintf("'%s' is already installed.", pkg))
                return(repo)
            }
            ## Get the tarball URL.
            if (identical(release, "latest")) {
                jsonUrl <- paste(
                    "https://api.github.com",
                    "repos",
                    repo,
                    "releases",
                    "latest",
                    sep = "/"
                )
                json <- withCallingHandlers(expr = {
                    tryCatch(expr = readLines(jsonUrl))
                }, warning = function(w) {
                    ## Ignore warning about missing final line in JSON return.
                    if (grepl(
                        pattern = "incomplete final line",
                        x = conditionMessage(w)
                    )) {
                        invokeRestart("muffleWarning")
                    }
                })
                ## Extract the tarball URL from the JSON output using base R.
                x <- unlist(strsplit(x = json, split = ",", fixed = TRUE))
                x <- grep(pattern = "tarball_url", x = x, value = TRUE)
                x <- strsplit(x = x, split = "\"", fixed = TRUE)[[1L]][[4L]]
                url <- x
            } else {
                url <- paste(
                    "https://github.com",
                    repo,
                    "archive",
                    paste0(release, ".tar.gz"),
                    sep = "/"
                )
            }
            tarfile <- tempfile(fileext = ".tar.gz")
            utils::download.file(
                url = url,
                destfile = tarfile,
                quiet = FALSE
            )
            ## Using a random string of 'A-Za-z' here for extracted directory.
            exdir <- file.path(
                tempdir(),
                paste0(
                    "untar-",
                    paste0(
                        sample(c(LETTERS, letters))[1L:6L],
                        collapse = ""
                    )
                )
            )
            utils::untar(
                tarfile = tarfile,
                exdir = exdir,
                verbose = TRUE
            )
            ## Locate the extracted package directory.
            pkgdir <- list.dirs(
                path = exdir,
                full.names = TRUE,
                recursive = FALSE
            )
            stopifnot(
                identical(length(pkgdir), 1L),
                isTRUE(dir.exists(pkgdir))
            )
            utils::install.packages(pkgs = pkgdir, repos = NULL, type = "source")
            ## Clean up temporary files.
            file.remove(tarfile)
            unlink(exdir, recursive = TRUE)
            repo
        }
    )
    invisible(out)
}
