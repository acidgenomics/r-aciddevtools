#' Install packages from GitHub
#'
#' @details
#' This variant doesn't require `GITHUB_PAT`.
#' If you have a `GITHUB_PAT` defined, can use `install()` directly instead.
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
#' @note Updated 2021-08-22.
#'
#' @inheritParams params
#' @param repo `character`.
#'   Repository address(es) in the format `owner/repo`.
#' @param tag `character`.
#'   Release version tag.
#'   Specific release must match the tag on GitHub (e.g. `"v1.0.0"`).
#' @param ... Passthrough arguments to `install()`.
#'
#' @return Invisible `list`.
#'   Metadata containing `repo`, `lib`, and whether packages were installed.
#'
#' @seealso
#' - `remotes::install_github()`.
#' - `install.packages()`.
#'
#' @examples
#' testlib <- file.path(tempdir(), "testlib")
#' unlink(testlib, recursive = TRUE)
#' out <- installGitHub(
#'     repo = "acidgenomics/r-goalie",
#'     tag = "v0.5.2",
#'     dependencies = FALSE,
#'     lib = testlib,
#'     reinstall = TRUE
#' )
#' print(out)
#' list.dirs(path = testlib, full.names = FALSE, recursive = FALSE)
#' unlink(testlib, recursive = TRUE)
installGitHub <- function(
    repo,
    tag,
    lib = .libPaths()[[1L]],
    reinstall = TRUE,
    ...
) {
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        all(grepl(x = repo, pattern = "^[^/]+/[^/]+$")),
        is.character(tag) && identical(length(tag), 1L),
        is.logical(reinstall) && identical(length(reinstall), 1L),
        identical(length(repo), length(tag))
    )
    if (isFALSE(dir.exists(lib))) {
        dir.create(lib)
    }
    lib <- normalizePath(lib, mustWork = TRUE)
    out <- mapply(
        repo = repo,
        tag = tag,
        MoreArgs = list("reinstall" = reinstall),
        FUN = function(repo, tag, reinstall) {
            pkg <- basename(repo)
            pkg <- sub(pattern = "^r-", replacement = "", x = pkg)
            if (
                isFALSE(reinstall) &&
                .isInstalled(pkg, lib = lib)
            ) {
                message(sprintf(
                    "'%s' is installed in '%s'.",
                    pkg, lib
                ))
                return(FALSE)
            }
            url <- paste(
                "https://github.com",
                repo,
                "archive",
                "refs",
                "tags",
                paste0(tag, ".tar.gz"),
                sep = "/"
            )
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
            install(
                pkgs = pkgdir,
                lib = lib,
                reinstall = reinstall,
                ...
            )
            ## Clean up temporary files.
            file.remove(tarfile)
            unlink(exdir, recursive = TRUE)
            TRUE
        }
    )
    invisible(list(
        "repo" = repo,
        "lib" = lib,
        "installed" = out
    ))
}
