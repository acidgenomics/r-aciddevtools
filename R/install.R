## FIXME Improve default rJava install with:
# install.packages("rJava", configure.args = "--disable-jri")

## FIXME Need to nuke the custom workarounds for geospatial...what a mess.
## GDAL is a terrible package to maintain across platforms.

## FIXME Need to suppress spam message from BiocManager:
## replaces Bioconductor standard repositories



#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2022-03-26.
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
#' @param configureArgs,configureVars `character` or named `list`.
#' *Used only for source installs.* If a character vector with no names is
#' supplied, the elements are concatenated into a single string (separated by
#' a space) and used as the value for the `--configure-args` or
#' `configure-vars` flag in the call to `R CMD INSTALL`. If the character
#' vector has names, these are assumed to identify values for
#' `--configure-args` or `--configure-vars` for individual packages. This
#' allows one to specify settings for an entire collection of packages which
#' will be used if any of those packages are to be installed.
#'
#' A named list can be used also to the same effect, and that allows
#' multi-element character strings for each package which are concatenated to
#' a single string to be used as the value for `--configure-args` and/or
#' `--configure-vars`.
#'
#' @param autoconf `logical(1)`.
#' Smartly Set configuration options internally automatically for some
#' packages that are problematic to install from source. Note that this will
#' override `configureArgs` and `configureVars` settings, when applicable.
#' Currently applies to: rgl.
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
#' Type of package to download and install. `"source"` is recommended by
#' default, but `"binary"` can be used on macOS or Windows to install
#' pre-built binaries from CRAN or Bioconductor.
#'
#' Note that installing from source requires the correct GCC and GNU Fortran
#' binaries to be installed, and Apple LLVM/Clang compilers should not be used
#' on macOS. Refer to [macOS development tools]() for details.
#'
#' [macOS development tools]: https://cran.r-project.org/bin/macosx/tools/
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
install <- function(pkgs,
                    configureArgs = getOption(x = "configure.args"),
                    configureVars = getOption(x = "configure.vars"),
                    autoconf = TRUE,
                    dependencies = NA,
                    lib = .libPaths()[[1L]],
                    type = getOption(x = "pkgType", default = "source"),
                    reinstall = TRUE) {
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        is.character(pkgs),
        is.logical(autoconf) && identical(length(autoconf), 1L),
        is.logical(reinstall) && identical(length(reinstall), 1L),
        is.character(lib) && identical(length(lib), 1L),
        is.character(type) && identical(length(type), 1L),
        isFALSE(file.exists(file.path("~", ".R", "Makevars")))
    )
    warnDefault <- getOption(x = "warn")
    options("warn" = 2L)
    if (isFALSE(dir.exists(lib))) {
        dir.create(lib)
    }
    lib <- normalizePath(lib, mustWork = TRUE)
    out <- vapply(
        X = pkgs,
        FUN = function(pkg) {
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
                pkgTypeDefault <- getOption(x = "pkgType")
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



#' macOS clang Makevars
#'
#' @note Updated 2022-03-25.
#' @noRd
.macosClangMakevars <- c(
    "CC" = paste(
        "clang",
        "-mmacosx-version-min=10.13"
    ),
    "CFLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "CPPFLAGS" = paste0(
        "-I",
        file.path("", "usr", "local", "include")
    ),
    "CXX" = paste(
        "clang++",
        "-mmacosx-version-min=10.13",
        "-std=gnu++14"
    ),
    "CXXFLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "CXX11" = paste(
        "clang++",
        "-mmacosx-version-min=10.13"
    ),
    "CXX11FLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "CXX14" = paste(
        "clang++",
        "-mmacosx-version-min=10.13"
    ),
    "CXX14FLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "CXX17" = paste(
        "clang++",
        "-mmacosx-version-min=10.13"
    ),
    "CXX17FLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "CXX20" = paste(
        "clang++",
        "-mmacosx-version-min=10.13"
    ),
    "CXX20FLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "FC" = paste(
        "gfortran",
        "-mmacosx-version-min=10.13"
    ),
    "FCFLAGS" = paste(
        "-Wall",
        "-g",
        "-O2",
        "$(LTO)"
    ),
    "FLIBS" = paste(
        paste0(
            "-L",
            file.path(
                "",
                "usr",
                "local",
                "gfortran",
                "lib",
                "gcc",
                "x86_64-apple-darwin18",
                "8.2.0"
            )
        ),
        paste0(
            "-L",
            file.path("", "usr", "local", "gfortran", "lib")
        ),
        "-lgfortran",
        "-lquadmath",
        "-lm"
    ),
    "LDFLAGS" = paste0(
        "-L",
        file.path("", "usr", "local", "lib")
    )
)



## nocov start

#' Autoconfigure a specified package
#'
#' This function will dynamically change configure arguments for some tricky
#' to install packages.
#'
#' @note Updated 2022-03-26.
#' @noRd
#'
#' @param args `list`.
#' Named list of arguments.
#'
#' @return `list`.
#' Arguments list to be passed to `BiocManager::install`.
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
    stopifnot(is.character(pkg) && length(pkg) == 1L)
    homebrewOpt <- .homebrewOpt()
    koopaOpt <- .koopaOpt()
    ## Configure geospatial packages (GDAL, GEOS, PROJ) from OSGeo, if needed.
    geospatial <- NULL
    if (isTRUE(pkg %in% c(
        "geos",
        "rgdal",
        "rgeos",
        "sf",
        "sp",
        "spatialreg",
        "spdep"
    ))) {
        geospatial <- list()
        if (any(dir.exists(c(
            file.path(koopaOpt, "gdal"),
            file.path(koopaOpt, "geos"),
            file.path(koopaOpt, "proj")
        )))) {
            geospatial[["opt"]] <- koopaOpt
        } else if (any(dir.exists(c(
            file.path(homebrewOpt, "gdal"),
            file.path(homebrewOpt, "geos"),
            file.path(homebrewOpt, "proj")
        )))) {
            geospatial[["opt"]] <- homebrewOpt
        } else {
            message("Using system packages for geospatial configuration.")
            geospatial <- NULL
        }
        if (is.list(geospatial)) {
            stopifnot(isTRUE(dir.exists(geospatial[["opt"]])))
            geospatial[["gdalDir"]] <-
                file.path(geospatial[["opt"]], "gdal")
            geospatial[["geosDir"]] <-
                file.path(geospatial[["opt"]], "geos")
            geospatial[["projDir"]] <-
                file.path(geospatial[["opt"]], "proj")
            ## Configuration handlers.
            geospatial[["gdalConfig"]] <-
                file.path(geospatial[["gdalDir"]], "bin", "gdal-config")
            geospatial[["geosConfig"]] <-
                file.path(geospatial[["geosDir"]], "bin", "geos-config")
            ## Directories.
            geospatial[["projData"]] <-
                file.path(geospatial[["projDir"]], "share", "proj")
            geospatial[["projInclude"]] <-
                file.path(geospatial[["projDir"]], "include")
            geospatial[["projLib"]] <-
                file.path(geospatial[["projDir"]], "lib")
            geospatial[["projShare"]] <-
                file.path(geospatial[["projDir"]], "share")
            stopifnot(
                all(dir.exists(c(
                    geospatial[["gdalDir"]],
                    geospatial[["geosDir"]],
                    geospatial[["projDir"]],
                    geospatial[["projData"]],
                    geospatial[["projInclude"]],
                    geospatial[["projLib"]],
                    geospatial[["projShare"]]
                ))),
                all(file.exists(
                    geospatial[["gdalConfig"]],
                    geospatial[["geosConfig"]]
                ))
            )
            .li <- "  -"
            invisible(lapply(
                X = c(
                    "Geospatial (OSGeo) libraries:",
                    paste(
                        .li, "GDAL:",
                        normalizePath(geospatial[["gdalDir"]])
                    ),
                    paste(
                        .li, "GEOS:",
                        normalizePath(geospatial[["geosDir"]])
                    ),
                    paste(
                        .li, "PROJ:",
                        normalizePath(geospatial[["projDir"]])
                    )
                ),
                FUN = message
            ))
            args[["type"]] <- "source"
        }
    }
    switch(
        EXPR = pkg,
        "data.table" = {
            if (
                .isMacOS() &&
                    isTRUE(grepl(
                        pattern = paste0(
                            "^",
                            file.path(
                                "",
                                "Library",
                                "Frameworks",
                                "R.framework",
                                "Resources"
                            )
                        ),
                        x = Sys.getenv("R_HOME")
                    ))
            ) {
                ## The prebuilt CRAN binary for macOS doesn't support parallel
                ## threads via OpenMP by default.
                args[["type"]] <- "source"
            }
        },
        "geos" = {
            ## NOTE May also need to configure "libgeos" dependency.
            if (is.list(geospatial)) {
                stopifnot(file.exists(geospatial[["geosConfig"]]))
                args[["configure.args"]] <-
                    paste0(
                        "--with-geos-config=",
                        geospatial[["geosConfig"]]
                    )
            }
        },
        "rgdal" = {
            ## NOTE Please note that 'rgdal' will be retired by the end of 2023,
            ## plan transition to sf/stars/'terra' functions using 'GDAL' and
            ## 'PROJ' at your earliest convenience.
            ##
            ## See also:
            ## https://cran.r-project.org/web/packages/rgdal/rgdal.pdf
            if (is.list(geospatial)) {
                stopifnot(
                    all(dir.exists(c(
                        geospatial[["projInclude"]],
                        geospatial[["projLib"]]
                    ))),
                    file.exists(geospatial[["gdalConfig"]])
                )
                configureArgs <- c(
                    paste0(
                        "--with-proj-include=",
                        geospatial[["projInclude"]]
                    ),
                    paste0(
                        "--with-proj-lib=",
                        geospatial[["projLib"]]
                    )
                )
                if (!identical(geospatial[["opt"]], homebrewOpt)) {
                    ## NOTE Including "gdal-config" currently causes this error
                    ## on macOS with Homebrew:
                    ## > ld: library not found for -lgeos-3
                    ## See also:
                    ## https://stackoverflow.com/questions/61108783/
                    configureArgs <- c(
                        configureArgs,
                        paste0(
                            "--with-gdal-config=",
                            geospatial[["geosConfig"]]
                        )
                    )
                }
                args[["configure.args"]] <- configureArgs
            }
        },
        "rgeos" = {
            if (is.list(geospatial)) {
                stopifnot(file.exists(geospatial[["geosConfig"]]))
                args[["configure.args"]] <-
                    paste0(
                        "--with-geos-config=",
                        geospatial[["geosConfig"]]
                    )
            }
        },
        "rgl" = {
            if (.isMacOS()) {
                ## See also:
                ## https://github.com/dmurdoch/rgl/issues/45
                args[["configure.args"]] <- "--disable-opengl"
                ## Avoid issue with missing webshot2 dependency.
                args[["dependencies"]] <- NA
            }
        },
        "sass" = {
            # FIXME Also do this for readxl.
            # FIXME Need to move out of autoconfig, rethink clang config...
        },
        "sf" = {
            if (is.list(geospatial)) {
                stopifnot(
                    all(file.exists(c(
                        geospatial[["gdalConfig"]],
                        geospatial[["geosConfig"]]
                    ))),
                    all(dir.exists(c(
                        geospatial[["projData"]],
                        geospatial[["projInclude"]],
                        geospatial[["projLib"]],
                        geospatial[["projShare"]]
                    )))
                )
                args[["configure.args"]] <- c(
                    paste0(
                        "--with-gdal-config=",
                        geospatial[["gdalConfig"]]
                    ),
                    paste0(
                        "--with-geos-config=",
                        geospatial[["geosConfig"]]
                    ),
                    paste0(
                        "--with-proj-data=",
                        geospatial[["projData"]]
                    ),
                    paste0(
                        "--with-proj-include=",
                        geospatial[["projInclude"]]
                    ),
                    paste0(
                        "--with-proj-lib=",
                        geospatial[["projLib"]]
                    ),
                    paste0(
                        "--with-proj-share=",
                        geospatial[["projShare"]]
                    )
                )
            }
            args[["dependencies"]] <- NA
        }
    )
    ## Inform the user about configuration argument overrides.
    if (!is.null(args[["configure.args"]])) {
        invisible(lapply(
            X = c(
                "Configuration via '--configure.args':",
                paste0("  ", args[["configure.args"]])
            ),
            FUN = message
        ))
    }
    if (!is.null(args[["configure.vars"]])) {
        invisible(lapply(
            X = c(
                "Configuration via 'configure-vars':",
                paste0("  ", args[["configure.vars"]])
            ),
            FUN = message
        ))
    }
    args
}

## nocov end
