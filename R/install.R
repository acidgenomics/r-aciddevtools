## FIXME REWORK THIS:
# FIXME Define this in r-aciddevtools instead.
#koopa::macos_install_r_sf() { # {{{1
#    # """
#    # Install R sf package.
#    # @note Updated 2020-07-16.
#    # """
#    koopa::assert_has_no_args "$#"
#    koopa::assert_is_installed Rscript
#    koopa::is_r_package_installed sf && return 0
#    Rscript -e "\
#        install.packages(
#            pkgs = \"sf\",
#            type = \"source\",
#            configure.args = paste(
#                \"--with-gdal-config=/usr/local/opt/gdal/bin/gdal-config\",
#                \"--with-geos-config=/usr/local/opt/geos/bin/geos-config\",
#                \"--with-proj-data=/usr/local/opt/proj/share/proj\",
#                \"--with-proj-include=/usr/local/opt/proj/include\",
#                \"--with-proj-lib=/usr/local/opt/proj/lib\",
#                \"--with-proj-share=/usr/local/opt/proj/share\"
#            )
#        )"
#    return 0
#}

# FIXME MOVE THESE TO ACIDDEVTOOLS.
#koopa::linux_install_r_geos() { # {{{1
#    # """
#    # Install R rgeos package.
#    # @note Updated 2021-01-20.
#    # """
#    local geos_prefix make_prefix
#    if koopa::is_r_package_installed rgeos
#    then
#        koopa::alert_note 'rgeos is already installed.'
#        return 0
#    fi
#    koopa::assert_is_installed Rscript
#    koopa::assert_is_not_file '/usr/bin/geos-config'
#    # How to enable versioned support, if necessary.
#    # > app_prefix="$(koopa::app_prefix)"
#    # > geos_version="$(koopa::variable 'geos')"
#    # > geos_prefix="${app_prefix}/geos/${geos_version}"
#    make_prefix="$(koopa::make_prefix)"
#    geos_prefix="$make_prefix"
#    Rscript -e "\
#        install.packages(
#            pkgs = \"rgeos\",
#            type = \"source\",
#            repos = \"https://cran.rstudio.com\",
#            configure.args = paste(
#                \"--with-geos-config=${geos_prefix}/bin/geos-config\"
#            )
#        )"
#    return 0
#}
#
## FIXME MOVE THESE TO ACIDDEVTOOLS.
#koopa::linux_install_r_sf() { # {{{1
#    # """
#    # Install R sf package.
#    # @note Updated 2021-01-20.
#    # """
#    local gdal_prefix geos_prefix make_prefix pkg_config_arr proj_prefix
#    if koopa::is_r_package_installed sf
#    then
#        koopa::alert_note 'sf is already installed.'
#        return 0
#    fi
#    koopa::assert_is_installed Rscript
#    koopa::assert_is_not_file \
#        '/usr/bin/gdal-config' \
#        '/usr/bin/geos-config' \
#        '/usr/bin/proj'
#    # How to enable versioned support, if necessary.
#    # > app_prefix="$(koopa::app_prefix)"
#    # > gdal_version="$(koopa::variable 'gdal')"
#    # > gdal_prefix="${app_prefix}/gdal/${gdal_version}"
#    # > geos_version="$(koopa::variable 'geos')"
#    # > geos_prefix="${app_prefix}/geos/${geos_version}"
#    # > proj_version="$(koopa::variable 'proj')"
#    # > proj_prefix="${app_prefix}/proj/${proj_version}"
#    make_prefix="$(koopa::make_prefix)"
#    gdal_prefix="$make_prefix"
#    geos_prefix="$make_prefix"
#    proj_prefix="$make_prefix"
#    pkg_config_arr=(
#        "${gdal_prefix}/lib/pkgconfig"
#        "${proj_prefix}/lib/pkgconfig"
#        '/usr/local/lib/pkgconfig'
#    )
#    PKG_CONFIG_PATH="$(koopa::paste0 "${pkg_config_arr[@]}")"
#    export PKG_CONFIG_PATH
#    koopa::dl PKG_CONFIG_PATH "$PKG_CONFIG_PATH"
#    koopa::dl 'gdal config' "$(pkg-config --libs gdal)"
#    koopa::dl 'geos config' "$(geos-config --libs)"
#    koopa::dl 'proj config' "$(pkg-config --libs proj)"
#    Rscript -e "\
#        install.packages(
#            pkgs = \"sf\",
#            type = \"source\",
#            repos = \"https://cran.rstudio.com\",
#            configure.args = paste(
#                \"--with-gdal-config=${gdal_prefix}/bin/gdal-config\",
#                \"--with-geos-config=${geos_prefix}/bin/geos-config\",
#                \"--with-proj-data=${proj_prefix}/share/proj\",
#                \"--with-proj-include=${proj_prefix}/include\",
#                \"--with-proj-lib=${proj_prefix}/lib\",
#                \"--with-proj-share=${proj_prefix}/share\"
#            )
#        )"
#    return 0
#}



#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2021-04-27.
#'
#' @inheritParams params
#' @param pkgs `character`.
#'   Package names to install.
#'   By default, strings are passed to [BiocManager::install()].
#'
#'   Special cases:
#'
#'   - Package tarball files and remote URLs (i.e. from CRAN or Bioconductor)
#'     are supported.
#'   - Strings matching  "USER/REPO" are treated as GitHub repositories,
#'     and installed using [remotes::install_github()].
#'   - Strings ending with ".git" are treated as Git repositories, and
#'     installed using [remotes::install_git()].
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
#' @param lib `character`.
#'   Destination library directory paths.
#'   Defaults to the first element of `.libPaths()`.
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
#' @return Invisible `character`.
#'   Package names defined in the `pkgs` argument.
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
    type = getOption("pkgType"),
    reinstall = TRUE
) {
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        is.character(pkgs),
        is.logical(autoconf) && identical(length(autoconf), 1L),
        is.logical(reinstall) && identical(length(reinstall), 1L)
    )
    warn <- getOption("warn")
    options("warn" = 2L)
    .installIfNecessary(c("BiocManager", "remotes"))
    out <- lapply(
        X = pkgs,
        FUN = function(pkg) {
            ## Direct install from Git repo.
            if (grepl(pattern = "\\.git$", x = pkg)) {
                url <- pkg
                pkg <- sub(
                    pattern = "\\.git$",
                    replacement = "",
                    x = basename(url)
                )
                if (isTRUE(.isInstalled(pkg)) && !isTRUE(reinstall)) {
                    message(sprintf("'%s' is installed.", pkg))
                    return(pkg)
                }
                message(sprintf(
                    "Installing '%s' from '%s' with '%s::%s'.",
                    pkg, url, "remotes", "install_git"
                ))
                stopifnot(requireNamespace("remotes", quietly = TRUE))
                remotes::install_git(url)
                return(pkg)
            }
            ## Enable version-specific install from package tarball URLs.
            if (
                file.exists(pkg) ||
                grepl(pattern = "^http(s)?://", x = pkg)
            ) {
                url <- pkg
                if (file.exists(url)) {
                    url <- normalizePath(url)
                }
                pkg <- strsplit(basename(url), "[_-]")[[1L]][[1L]]
                if (isTRUE(.isInstalled(pkg)) && !isTRUE(reinstall)) {
                    message(sprintf("'%s' is installed.", pkg))
                    return(pkg)
                }
                ## Alternatively, can use `devtools::install_version()`.
                message(sprintf(
                    "Installing '%s' from '%s' with '%s::%s'.",
                    pkg, url, "utils", "install.packages"
                ))
                utils::install.packages(
                    pkgs = url,
                    repos = NULL,
                    type = "source"
                )
                return(pkg)
            }
            if (isTRUE(.isInstalled(pkg)) && !isTRUE(reinstall)) {
                message(sprintf("'%s' is installed.", basename(pkg)))
                return(pkg)
            }
            if (grepl(pattern = "^[^/]+/[^/]+$", x = pkg)) {
                ## remotes-specific (Git).
                args <- list(upgrade = "always")
            } else {
                ## BiocManager-specific (Bioconductor/CRAN).
                args <- list(
                    site_repository = "https://r.acidgenomics.com",
                    ask = FALSE,
                    update = FALSE
                )
            }
            if (isTRUE(autoconf)) {
                switch(
                    EXPR = pkg,
                    "data.table" = {
                        ## Ensure we're building from source on macOS; the
                        ## prebuilt binary doesn't support parallel threads
                        ## via OpenMP by default.
                        ## See also:
                        ## https://github.com/Rdatatable/data.table/wiki/
                        ##   Installation#openmp-enabled-compiler-for-mac
                        type <- "source"
                    },
                    "rgl" = {
                        ## Might only want to set this on macOS.
                        ## https://github.com/dmurdoch/rgl/issues/45
                        configureArgs <- "--disable-opengl"
                    }
                )
            }
            args <- c(
                args,
                list(
                    pkgs = pkg,
                    checkBuilt = TRUE,
                    configure.args = configureArgs,
                    configure.vars = configureVars,
                    dependencies = dependencies,
                    type = type
                )
            )
            stopifnot(requireNamespace("BiocManager", quietly = TRUE))
            message(sprintf(
                "Installing '%s' with '%s::%s'.",
                pkg, "BiocManager", "install"
            ))
            do.call(what = BiocManager::install, args = args)
            pkg
        }
    )
    options("warn" = warn)
    invisible(out)
}
