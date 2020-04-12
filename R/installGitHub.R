## Passing tar.gz release file from GitHub (`tarball_url` key) currently results
## in untar2 "skipping pax global extended headers" warning in
## `install.packages()` call below. Note that use of `zipball_url` doesn't work
## well, resulting in `rawToChar` embedded nul error.



#' Install package from GitHub
#'
#' @details
#' This variant doesn't require `GITHUB_PAT`.
#' If you have a `GITHUB_PAT` defined, can use [install()] directly instead.
#' Intended for use inside container images, where a PAT may not be used.
#'
#' @export
#' @note Updated 2020-04-11.
#'
#' @param repo `character`.
#'   Repository address(es) in the format `username/repo`.
#'
#' @return Invisible `character`.
#'   Repository address defined in `repo` argument.
#'
#' @seealso
#' - `remotes::install_github`.
#' - `install.packages`.
#'
#' @examples
#' installGitHub(
#'     repo = c(
#'         "acidgenomics/acidbase",
#'         "acidgenomics/goalie"
#'     )
#' )
installGitHub <- function(
    repo,
    version = "latest",
    reinstall = FALSE
) {
    assert(
        allAreMatchingRegex(x = repo, pattern = "^[^/]+/[^/]+$"),
        isCharacter(version),
        isFlag(reinstall)
    )
    if (length(repo) > 1L && identical(version, "latest")) {
        version <- rep(version, times = length(repo))
    }
    assert(areSameLength(repo, version))
    out <- mapply(
        repo = repo,
        version = version,
        MoreArgs = list(reinstall = reinstall),
        FUN = function(repo, version, reinstall) {
            user <- dirname(repo)
            pkg <- basename(repo)
            if (!isTRUE(reinstall) && isInstalled(pkg)) {
                message(sprintf("'%s' is already installed.", pkg))
                return(repo)
            }
            ## FIXME Add URL support for specific tagged release.
            ## https://github.com/acidgenomics/basejump/releases/tag/v0.12.5
            jsonUrl <- pasteURL(
                "api.github.com",
                "repos",
                repo,
                "releases",
                "latest",
                protocol = "https"
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
            x <- strsplit(x = json, split = ",", fixed = TRUE)[[1L]]
            x <- grep(pattern = "tarball_url", x = x, value = TRUE)
            x <- strsplit(x = x, split = "\"", fixed = TRUE)[[1L]][[4L]]
            url <- x
            tarfile <- tempfile(fileext = ".tar.gz")
            download.file(
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
            untar(
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
            assert(isADir(pkgdir))
            install.packages(pkgs = pkgdir, repos = NULL, type = "source")
            ## Clean up temporary files.
            file.remove(tarfile)
            unlink(exdir, recursive = TRUE)
        }
    )
    invisible(out)
}
