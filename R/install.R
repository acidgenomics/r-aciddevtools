## Tricky to install in r-devel:
## - gert
## - sass
## - systemfonts



#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2022-04-28.
#'
#' @inheritParams params
#'
#' @param pkgs `character`.
#' Package names to install.
#' By default, strings are passed to `BiocManager::install()`.
#'
#' Special cases:
#'
#' - Package tarball files and remote URLs (i.e. from CRAN or Bioconductor)
#' are supported.
#' - Strings matching  "USER/REPO" are treated as GitHub repositories,
#' and installed using `remotes::install_github()`.
#' - Strings ending with ".git" are treated as Git repositories, and
#' installed using `remotes::install_git()`.
#'
#' @param dependencies `logical(1)`, `character`, or `NA`.
#' - `TRUE`/`FALSE` indicating whether to install uninstalled packages which
#' these packages depend on/link to/import/suggest.
#' - Can pass a `character` vector, a subset of
#' `c("Depends", "Imports", " LinkingTo", "Suggests", "Enhances")`.
#' - Can pass `NA`, the default for
#' [`install.packages()`][utils::install.packages], which means
#' `c("Depends", "Imports", "LinkingTo")`.
#'
#' @return Invisible `list`.
#' Contains information on `pkgs` and `lib` defined.
#'
#' @examples
#' ## > testlib <- file.path(tempdir(), "testlib")
#' ## > unlink(testlib, recursive = TRUE)
#' ## > out <- install(
#' ## >     pkgs = "BiocGenerics",
#' ## >     dependencies = FALSE,
#' ## >     lib = file.path(tempdir(), "testlib")
#' ## > )
#' ## > print(out)
#' ## > list.dirs(path = testlib, full.names = FALSE, recursive = FALSE)
#' ## > unlink(testlib, recursive = TRUE)
install <-
    function(pkgs,
             dependencies = NA,
             lib = .libPaths()[[1L]],
             reinstall = TRUE) {
        stopifnot(
            requireNamespace("utils", quietly = TRUE),
            is.character(pkgs),
            is.character(lib) && identical(length(lib), 1L),
            is.logical(reinstall) && identical(length(reinstall), 1L)
        )
        warnDefault <- getOption(x = "warn")
        options("warn" = 2L)
        if (isFALSE(dir.exists(lib))) {
            message(sprintf("Creating R package library at '%s'.", lib))
            dir.create(lib)
        }
        lib <- normalizePath(lib, mustWork = TRUE)
        out <- vapply(
            X = pkgs,
            FUN = .install,
            FUN.VALUE = logical(1L),
            dependencies = dependencies,
            lib = lib,
            reinstall = reinstall,
            USE.NAMES = FALSE
        )
        options("warn" = warnDefault)
        invisible(list(
            "pkgs" = pkgs,
            "lib" = lib,
            "installed" = out
        ))
    }



#' Install an individual package
#'
#' @note Updated 2022-04-28.
#' @noRd
.install <-
    function(
        pkg,
        lib,
        dependencies,
        reinstall) {
        if (
            grepl(pattern = "\\.git$", x = pkg)
        ) {
            mode <- "gitRepo"
        } else if (
            file.exists(pkg) ||
            grepl(pattern = "^http(s)?://", x = pkg)
        ) {
            mode <- "tarball"
        } else if (
            grepl(pattern = "^[^/]+/[^/]+$", x = pkg)
        ) {
            mode <- "gitHub"
        } else {
            mode <- "default"
        }
        ## Standard arguments, shared across all installer calls.
        args <- list(
            "checkBuilt" = TRUE,
            "dependencies" = dependencies,
            "lib" = lib
        )
        switch(
            EXPR = mode,
            "default" = {
                whatPkg <- "BiocManager"
                whatFun <- "install"
                args <- append(
                    x = list(
                        "pkgs" = pkg,
                        "ask" = FALSE,
                        "force" = TRUE,
                        "site_repository" = "https://r.acidgenomics.com",
                        "update" = FALSE
                    ),
                    values = args
                )
            },
            "gitHub" = {
                repo <- pkg
                pkg <- basename(repo)
                pkg <- sub(
                    pattern = "^r-",
                    replacement = "",
                    x = pkg
                )
                whatPkg <- "remotes"
                whatFun <- "install_github"
                args <- append(
                    x = list(
                        "repo" = repo,
                        "force" = TRUE,
                        "upgrade" = "always"
                    ),
                    values = args
                )
            },
            "gitRepo" = {
                url <- pkg
                pkg <- sub(
                    pattern = "\\.git$",
                    replacement = "",
                    x = basename(pkg)
                )
                pkg <- sub(
                    pattern = "^r-",
                    replacement = "",
                    x = pkg
                )
                whatPkg <- "remotes"
                whatFun <- "install_git"
                args <- append(
                    x = list(
                        "url" = url,
                        "force" = TRUE
                    ),
                    values = args
                )
            },
            "tarball" = {
                url <- pkg
                if (file.exists(url)) {
                    url <- normalizePath(url)
                }
                pkg <- basename(url)
                pkg <- sub(pattern = "^r-", replacement = "", x = pkg)
                pkg <- strsplit(
                    x = pkg,
                    split = "[_-]",
                    fixed = FALSE
                )
                pkg <- pkg[[1L]][[1L]]
                whatPkg <- "utils"
                whatFun <- "install.packages"
                args <- append(
                    x = list(
                        "pkgs" = url,
                        "repos" = NULL,
                        "type" = "source"
                    ),
                    values = args
                )
            }
        )
        stopifnot(is.character(pkg) && length(pkg) == 1L)
        args <- args[unique(names(args))]
        if (
            isTRUE(.isInstalled(pkg, lib = lib)) &&
            isFALSE(reinstall)
        ) {
            message(sprintf("'%s' is installed in '%s'.", pkg, lib))
            return(FALSE)
        }
        message(sprintf(
            "Installing '%s' with '%s::%s' in '%s'.",
            pkg, whatPkg, whatFun, lib
        ))
        .installIfNecessary(pkgs = whatPkg, lib = lib)
        stopifnot(requireNamespace(whatPkg, quietly = TRUE))
        what <- get(
            x = whatFun,
            envir = asNamespace(whatPkg),
            inherits = FALSE
        )
        stopifnot(is.function(what))
        ## Ensure data.table always installs from source on macOS, to enable
        ## support for OpenMP and multiple threads.
        if (
            {
                .isMacosFramework() &&
                    isTRUE(pkg %in% "data.table")
            } ||
            {
                !.isMacosFramework() &&
                    .isMacOS() &&
                    isTRUE(pkg %in% "gert")
            }
        ) {
            .installWithMakevars(
                what = what,
                args = args,
                ## Usage of `.macosGccMakevars()` should also work here.
                makevars = .macosClangMakevars(),
                lib = lib
            )
            return(TRUE)
        }
        suppressMessages({
            do.call(what = what, args = args)
        })
        TRUE
    }



#' Install packages, if necessary
#'
#' @note Updated 2021-08-22.
#' @noRd
#'
#' @param pkgs `character`.
#' R package names to install.
#'
#' @param lib `character(1)`.
#' R package library path.
#' See `.libPaths()` for details.
#'
#' @return Invisible `logical(1)`
#'
#' @examples
#' ## > .installIfNecessary("BiocManager")
.installIfNecessary <- function(pkgs, lib = .libPaths()[[1L]]) {
    warn <- getOption(x = "warn")
    options("warn" = 2L)
    invisible(lapply(
        X = pkgs,
        FUN = function(pkg) {
            if (!requireNamespace(pkg, quietly = TRUE)) {
                utils::install.packages(
                    pkgs = pkg,
                    repos = .cran,
                    lib = lib
                )
            }
        }
    ))
    options("warn" = warn)
    invisible(TRUE)
}



#' Install with Makevars
#'
#' @note Updated 2022-04-28.
#' @noRd
.installWithMakevars <-
    function(what, args, makevars, lib) {
        .installIfNecessary(pkgs = "withr", lib = lib)
        stopifnot(requireNamespace("withr", quietly = TRUE))
        args[["type"]] <- "source"
        withr::with_makevars(
            new = makevars,
            code = {
                do.call(what = what, args = args)
            },
            assignment = "="
        )
}
