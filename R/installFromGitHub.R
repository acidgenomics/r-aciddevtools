#' Install packages from GitHub
#'
#' @details
#' This variant doesn't require `GITHUB_PAT`. If you have a `GITHUB_PAT`
#' defined, can use `install()` directly instead. Intended for use inside
#' container images, where a PAT may not be used.
#'
#' @section GitHub API:
#'
#' - All releases JSON:
#' `https://api.github.com/repos/:owner/:repo/releases`
#' - Latest release JSON:
#' `https://api.github.com/repos/:owner/:repo/releases/latest`
#' - Specific release JSON (requires numeric release ID, not tag name):
#' `https://api.github.com/repos/:owner/:repo/releases/:release_id`
#' - Specific tagged release tarball:
#' `https://github.com/:owner/:repo/archive/:tag.tar.gz`
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @inheritParams params
#'
#' @param repo `character`.
#' Repository address(es) in the format `owner/repo`.
#'
#' @param tag `character` or `missing`.
#' Release version tag.
#' Specific release must match the tag on GitHub (e.g. `"v1.0.0"`).
#' Required except when `branch` is declared.
#'
#' @param branch `character` or `missing`.
#' Branch name (e.g. `"develop"`).
#' Can specify this instead of `tag`.
#'
#' @param ... Passthrough arguments to `install()`.
#'
#' @return Invisible `list`.
#' Metadata containing `repo`, `lib`, and whether packages were installed.
#'
#' @seealso
#' - `remotes::install_github()`.
#' - `install.packages()`.
#'
#' @examples
#' testlib <- file.path(tempdir(), "testlib")
#' unlink(testlib, recursive = TRUE)
#' out <- installFromGitHub(
#'     repo = paste(
#'         "acidgenomics",
#'         "r-goalie",
#'         sep = "/"
#'     ),
#'     tag = "v0.5.2",
#'     dependencies = FALSE,
#'     lib = testlib,
#'     reinstall = TRUE
#' )
#' print(out)
#' sort(list.dirs(path = testlib, full.names = FALSE, recursive = FALSE))
#' unlink(testlib, recursive = TRUE)
installFromGitHub <-
    function(repo,
             tag,
             branch,
             lib = .libPaths()[[1L]], # nolint
             reinstall = TRUE,
             ...) {
        if (
            (missing(tag) && missing(branch)) ||
                (!missing(tag) && !missing(branch))
        ) {
            stop("Specify either 'tag' or 'branch'.")
        }
        if (!missing(tag)) {
            ref <- tag
            refType <- "tag"
        } else if (!missing(branch)) {
            ref <- branch
            refType <- "branch"
        }
        stopifnot(
            .requireNamespaces("utils"),
            all(grepl(x = repo, pattern = "^[^/]+/[^/]+$")),
            identical(length(repo), length(ref)),
            .isFlag(reinstall)
        )
        if (isFALSE(dir.exists(lib))) {
            dir.create(lib)
        }
        lib <- .realpath(lib)
        out <- Map(
            repo = repo,
            ref = ref,
            MoreArgs = list(
                "refType" = refType,
                "reinstall" = reinstall
            ),
            f = function(repo, ref, refType, reinstall) {
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
                    switch(
                        EXPR = refType,
                        "branch" = "heads",
                        "tag" = "tags"
                    ),
                    paste0(ref, ".tar.gz"),
                    sep = "/"
                )
                tarfile <- tempfile(fileext = ".tar.gz")
                utils::download.file(
                    url = url,
                    destfile = tarfile,
                    quiet = FALSE
                )
                ## Using a random string of 'A-Za-z' here for directory.
                exdir <- file.path(
                    .tempdir2(),
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
                stopifnot(.isADir(pkgdir))
                install(
                    pkgs = pkgdir,
                    lib = lib,
                    reinstall = reinstall,
                    ...
                )
                ## Clean up temporary files.
                file.remove(tarfile)
                .unlink2(exdir)
                TRUE
            }
        )
        out <- unlist(out, recursive = FALSE)
        invisible(list(
            "repo" = repo,
            "lib" = lib,
            "installed" = out
        ))
    }
