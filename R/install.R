#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2023-05-17.
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
#' @param type `character(1)`.
#' Type of package to download and install: `"binary"`, `"source"`, or
#' `"both"` (prefer binary but fall back to source).
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
             lib = .libPaths()[[1L]], # nolint
             dependencies = NA,
             type = getOption("pkgType", default = "source"),
             reinstall = TRUE) {
        stopifnot(
            .requireNamespaces("utils"),
            is.character(pkgs),
            .isString(lib),
            is.logical(dependencies) || is.character(dependencies),
            .isString(type),
            .isFlag(reinstall)
        )
        ## > warnDefault <- getOption("warn")
        ## > options("warn" = 2L) # nolint
        if (isFALSE(dir.exists(lib))) {
            message(sprintf("Creating R package library at '%s'.", lib))
            dir.create(lib)
        }
        lib <- .realpath(lib)
        out <- vapply(
            X = pkgs,
            FUN = .install,
            FUN.VALUE = logical(1L),
            dependencies = dependencies,
            type = type,
            lib = lib,
            reinstall = reinstall,
            USE.NAMES = FALSE
        )
        ## > options("warn" = warnDefault) # nolint
        invisible(list(
            "pkgs" = pkgs,
            "dependencies" = dependencies,
            "type" = type,
            "lib" = lib,
            "installed" = out
        ))
    }



#' Install an individual package
#'
#' @note Updated 2022-10-20.
#' @noRd
.install <-
    function(pkg,
             lib,
             dependencies,
             type,
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
                        "type" = type,
                        "site_repository" = "https://r.acidgenomics.com",
                        "update" = FALSE,
                        "ask" = FALSE,
                        "force" = TRUE
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
                    url <- .realpath(url)
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
        stopifnot(
            is.character(pkg),
            identical(length(pkg), 1L)
        )
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
        stopifnot(.requireNamespaces(whatPkg))
        what <- get(
            x = whatFun,
            envir = asNamespace(whatPkg),
            inherits = FALSE
        )
        stopifnot(is.function(what))
        ## Ensure data.table always installs from source on macOS, to enable
        ## support for OpenMP and multiple threads.
        if (.isMacosFramework() && isTRUE(pkg %in% "data.table")) {
            args[["type"]] <- "source"
        }
        suppressMessages({
            do.call(what = what, args = args)
        })
        TRUE
    }



#' Install packages, if necessary
#'
#' @note Updated 2023-05-17.
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
.installIfNecessary <-
    function(pkgs,
             lib = .libPaths()[[1L]] # nolint
    ) {
        ## > warn <- getOption(x = "warn")
        ## > options("warn" = 2L) # nolint
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
        ## > options("warn" = warn) # nolint
        invisible(TRUE)
    }
