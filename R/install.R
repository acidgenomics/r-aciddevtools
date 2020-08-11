#' Install packages from Bioconductor, CRAN, or a Git remote
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @inheritParams params
#' @param pkgs `character`.
#'   Package names to install.
#'   Package names containing a "/" are treated as GitHub repositories and
#'   installed using [remotes::install_github()].
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
    dependencies = NA,
    lib = .libPaths()[[1L]],
    type = getOption("pkgType"),
    reinstall = TRUE
) {
    stopifnot(
        requireNamespace("utils", quietly = TRUE),
        is.character(pkgs),
        is.logical(reinstall) && identical(length(reinstall), 1L)
    )
    ## Treat all warnings as errors.
    warn <- getOption("warn")
    options("warn" = 2L)
    ## Ensure dependency packages are installed.
    invisible(lapply(
        X = c("BiocManager", "remotes"),
        FUN = function(pkg) {
            if (!requireNamespace(pkg, quietly = TRUE)) {
                utils::install.packages(
                    pkgs = pkg,
                    repos = "https://cloud.r-project.org"
                )
            }
        }
    ))
    out <- lapply(
        X = pkgs,
        FUN = function(pkg) {
            ## Enable version-specific install from package tarball URLs.
            if (grepl(pattern = "^http(s)?://", x = pkg)) {
                url <- pkg
                pkg <- strsplit(basename(url), "[_-]")[[1L]][[1L]]
                if (isTRUE(.isInstalled(pkg)) && !isTRUE(reinstall)) {
                    message(sprintf("'%s' is already installed.", pkg))
                    return(pkg)
                }
                ## Alternatively, can use `devtools::install_version()`.
                utils::install.packages(pkgs = url, repos = NULL)
                return(pkg)
            }
            if (isTRUE(.isInstalled(pkg)) && !isTRUE(reinstall)) {
                message(sprintf("'%s' is already installed.", basename(pkg)))
                return(pkg)
            }
            if (grepl(pattern = "/", x = pkg)) {
                ## remotes-specific (Git).
                args <- list(upgrade = "always")
            } else {
                ## BiocManager-specific (Bioconductor/CRAN).
                args <- list(ask = FALSE, update = TRUE)
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
            do.call(what = BiocManager::install, args = args)
            pkg
        }
    )
    options("warn" = warn)
    invisible(out)
}



## Updated 2020-08-11.
.isInstalled <- function(pkgs) {
    basename(pkgs) %in% rownames(utils::installed.packages())
}
