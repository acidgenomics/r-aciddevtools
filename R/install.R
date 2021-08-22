#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2021-08-22.
#'
#' @inheritParams params
#' @param pkgs `character`.
#'   Package names to install.
#'   By default, strings are passed to `BiocManager::install()`.
#'
#'   Special cases:
#'
#'   - Package tarball files and remote URLs (i.e. from CRAN or Bioconductor)
#'     are supported.
#'   - Strings matching  "USER/REPO" are treated as GitHub repositories,
#'     and installed using `remotes::install_github()`.
#'   - Strings ending with ".git" are treated as Git repositories, and
#'     installed using `remotes::install_git()`.
#' @param configureArgs,configureVars `character` or named `list`.
#'   *Used only for source installs.* If a character vector with no names is
#'   supplied, the elements are concatenated into a single string (separated by
#'   a space) and used as the value for the `--configure-args` or
#'   `configure-vars` flag in the call to `R CMD INSTALL`. If the character
#'   vector has names, these are assumed to identify values for
#'   `--configure-args` or `--configure-vars` for individual packages. This
#'   allows one to specify settings for an entire collection of packages which
#'   will be used if any of those packages are to be installed.
#'
#'   A named list can be used also to the same effect, and that allows
#'   multi-element character strings for each package which are concatenated to
#'   a single string to be used as the value for `--configure-args` and/or
#'   `--configure-vars`.
#' @param autoconf `logical(1)`.
#'   Smartly Set configuration options internally automatically for some
#'   packages that are problematic to install from source. Note that this will
#'   override `configureArgs` and `configureVars` settings, when applicable.
#'   Currently applies to: rgl.
#' @param dependencies `logical(1)`, `character`, or `NA`.
#'  - `TRUE`/`FALSE` indicating whether to install uninstalled packages which
#'    these packages depend on/link to/import/suggest.
#'  - Can pass a `character` vector, a subset of
#'    `c("Depends", "Imports", " LinkingTo", "Suggests", "Enhances")`.
#'  - Can pass `NA`, the default for
#'    [`install.packages()`][utils::install.packages], which means
#'    `c("Depends", "Imports", "LinkingTo")`.
#' @param type `character(1)`.
#'   Type of package to download and install. `"source"` is recommended by
#'   default, but `"binary"` can be used on macOS or Windows to install
#'   pre-built binaries from CRAN or Bioconductor.
#'
#'   Note that installing from source requires the correct GCC and GNU Fortran
#'   binaries to be installed, and Apple LLVM/Clang compilers should not be used
#'   on macOS. Refer to [macOS development tools]() for details.
#'
#'   [macOS development tools]: https://cran.r-project.org/bin/macosx/tools/
#'
#' @return Invisible `list`.
#'   Contains information on `pkgs` and `lib` defined.
#'
#' @examples
#' ## > install(pkgs = c("DESeq2", "edgeR"))
install <- function(
    pkgs,
    configureArgs = getOption("configure.args"),
    configureVars = getOption("configure.vars"),
    autoconf = TRUE,
    dependencies = TRUE,
    lib = .libPaths()[[1L]],
    type = getOption("pkgType", default = "source"),
    reinstall = TRUE
) {
    makevarsFile <- file.path("~", ".R", "Makevars")
    if (is.null(type)) {
        type <- "source"
    }
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        is.character(pkgs),
        is.logical(autoconf) && identical(length(autoconf), 1L),
        is.logical(reinstall) && identical(length(reinstall), 1L),
        is.character(lib) && identical(length(lib), 1L),
        is.character(type) && identical(length(type), 1L),
        isFALSE(file.exists(makevarsFile))
    )
    warnDefault <- getOption("warn")
    options("warn" = 2L)
    if (isFALSE(dir.exists(lib))) {
        dir.create(lib)  # nocov
    }
    lib <- normalizePath(lib, mustWork = TRUE)
    out <- vapply(
        X = pkgs,
        FUN = function(pkg) {
            stopifnot(isFALSE(file.exists(makevarsFile)))
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
                "configure.args" = configureArgs,
                "configure.vars" = configureVars,
                "dependencies" = dependencies,
                "lib" = lib,
                "type" = type
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
            args <- args[unique(names(args))]
            if (
                isTRUE(.isInstalled(pkg, lib = lib)) &&
                !isTRUE(reinstall)
            ) {
                message(sprintf("'%s' is installed in '%s'.", pkg, lib))
                return(FALSE)
            }
            message(sprintf(
                "Installing '%s' with '%s::%s' in '%s'.",
                pkg, whatPkg, whatFun, lib
            ))
            .installIfNecessary(whatPkg, lib = lib)
            stopifnot(requireNamespace(whatPkg, quietly = TRUE))
            if (isTRUE(autoconf)) {
                args <- .autoconf(args)
            }
            if (isTRUE("type" %in% names(args))) {
                pkgTypeDefault <- getOption("pkgType")
                options("pkgType" = args[["type"]])
            }
            what <- get(
                x = whatFun,
                envir = asNamespace(whatPkg),
                inherits = FALSE
            )
            stopifnot(is.function(what))
            do.call(what = what, args = args)
            if (isTRUE("type" %in% names(args))) {
                options("pkgType" = pkgTypeDefault)
            }
            if (isTRUE(autoconf) && file.exists(makevarsFile)) {
                file.remove(makevarsFile)
            }
            TRUE
        },
        FUN.VALUE = logical(1L),
        USE.NAMES = FALSE
    )
    options("warn" = warnDefault)
    invisible(list(
        "pkgs" = pkgs,
        "lib" = lib,
        "installed" = out
    ))
}



## nocov start

#' Autoconfigure a specified package
#'
#' This function will dynamically change configure arguments for some tricky
#' to install packages.
#'
#' @note Updated 2021-08-22.
#' @noRd
#'
#' @param args `list`.
#'   Named list of arguments.
#'
#' @return `list`.
#'   Arguments list to be passed to `BiocManager::install`.
.autoconf <- function(args) {
    pkg <- args[["pkgs"]]
    ## This handling currently applies to remotes `url` pass-in.
    if (is.null(pkg)) {
        if (!is.null(args[["repo"]])) {
            pkg <- basename(args[["repo"]])
            pkg <- sub(pattern = "^r-", replacement = "", x = pkg)
        } else if (!is.null(args[["url"]])) {
            pkg <- basename(args[["url"]])
            pkg <- sub(pattern = "\\.git$", replacement = "", x = pkg)
            pkg <- sub(pattern = "^r-", replacement = "", x = pkg)
        }
    }
    makevarsFile <- file.path("~", ".R", "Makevars")
    stopifnot(
        is.character(pkg) && length(pkg) == 1L,
        !file.exists(makevarsFile)
    )
    homebrewOpt <- .homebrewOpt()
    koopaOpt <- .koopaOpt()
    switch(
        EXPR = pkg,
        "data.table" = {
            if (
                .isMacOS() &&
                isTRUE(grepl(
                    pattern = "^/Library/Frameworks/R.framework/Resources",
                    x = Sys.getenv("R_HOME")
                ))
            ) {
                ## The prebuilt CRAN binary for macOS doesn't support parallel
                ## threads via OpenMP by default.
                ## See also:
                ## - https://github.com/Rdatatable/data.table/wiki/
                ##     Installation#openmp-enabled-compiler-for-mac
                args[["type"]] <- "source"
            }
        },
        "geos" = {
            if (.isLinux()) {
                opt <- koopaOpt
                geosDir <- file.path(opt, "geos")
                if (all(dir.exists(c(opt, geosDir)))) {
                    geosConfig <- file.path(geosDir, "bin", "geos-config")
                    stopifnot(file.exists(geosConfig))
                    args[["configure.args"]] <-
                        paste0("--with-geos-config=", geosConfig)
                }
            }
        },
        "rgl" = {
            if (.isMacOS()) {
                ## https://github.com/dmurdoch/rgl/issues/45
                args[["configure.args"]] <- "--disable-opengl"
            }
        },
        "sf" = {
            if (.isMacOS()) {
                opt <- homebrewOpt
            } else if (.isLinux()) {
                opt <- koopaOpt
            }
            gdalDir <- file.path(opt, "gdal")
            geosDir <- file.path(opt, "geos")
            projDir <- file.path(opt, "proj")
            if (all(dir.exists(c(opt, gdalDir, geosDir, projDir)))) {
                gdalConfig <- file.path(gdalDir, "bin", "gdal-config")
                geosConfig <- file.path(geosDir, "bin", "geos-config")
                projData <- file.path(projDir, "share", "proj")
                projInclude <- file.path(projDir, "include")
                projLib <- file.path(projDir, "lib")
                projShare <- file.path(projDir, "share")
                stopifnot(
                    file.exists(gdalConfig),
                    file.exists(geosConfig),
                    dir.exists(projData),
                    dir.exists(projInclude),
                    dir.exists(projLib)
                )
                configureArgs <- c(
                    paste0("--with-gdal-config=", gdalConfig),
                    paste0("--with-geos-config=", geosConfig),
                    paste0("--with-proj-data=", projData),
                    paste0("--with-proj-include=", projInclude),
                    paste0("--with-proj-lib=", projLib),
                    paste0("--with-proj-share=", projShare)
                )
                args[["configure.args"]] <- configureArgs
            }
            args[["dependencies"]] <- NA
        }
    )
    args
}

## nocov end
