#' Rebuild a binary tarball from a source tarball
#'
#' @export
#' @note Updated 2023-10-24.
#'
#' @param packageName `character(1)`.
#' Package name
#'
#' @param repo `character(1)`.
#' Drat repo directory path.
#'
#' @seealso
#' - `build()`.
#' - `publish()`.
#'
#' @examples
#' ## > rebuildBinary("AcidSingleCell")
rebuildBinary <- function(
        packageName,
        repo = file.path("~", "monorepo", "r-acidgenomics-com")
    ) {
    stopifnot(
        .isString(packageName),
        .isADir(repo)
    )
    contribDir <- file.path(repo, "src", "contrib")
    stopifnot(.isADir(contribDir))
    srcTarball <- sort(list.files(
        path = contribDir,
        pattern = packageName,
        full.names = TRUE
    ))
    stopifnot(.isAFile(srcTarball))
    command <- file.path(R.home(), "bin", "R")
    tempdir <- tempdir()
    message("Building binary tarball.")
    .shell(
        command = command,
        args = c(
            "CMD", "INSTALL", "--build",
            srcTarball
        ),
        wd = tempdir
    )
    binTarball <- sort(list.files(
        path = tempdir,
        pattern = "*.tgz",
        full.names = TRUE
    ))
    out <- .insertPackage(file = binTarball, repo = repo)
    unlink(tempdir, recursive = TRUE)
    invisible(out)
}
