#' Cache test files
#'
#' @export
#' @note Updated 2023-09-28.
#'
#' @param pkg `character(1)`.
#' Package name.
#'
#' @param files `character`.
#' File basenames relative to `remoteDir`.
#'
#' @param remoteDir `character(1)`.
#' Remote base URL.
#'
#' @return Invisible `character`.
#' File paths.
cacheTestFiles <- function(pkg, files, remoteDir) {
    stopifnot(
        .requireNamespaces(c("AcidBase", "goalie")),
        goalie::hasInternet(),
        goalie::isString(pkg),
        goalie::isCharacter(files),
        goalie::isAnExistingUrl(remoteDir)
    )
    cacheDir <- AcidBase::pkgCacheDir(.pkgName)
    cacheDir <- file.path(cacheDir, "testthat")
    cacheDir <- AcidBase::initDir(cacheDir)
    out <- vapply(
        X = files,
        FUN = function(file, remoteDir) {
            destfile <- file.path(cacheDir, file)
            if (!goalie::isAFile(destfile)) {
                AcidBase::download(
                    url = AcidBase::pasteUrl(remoteDir, file),
                    destfile = destfile
                )
            }
            destfile
        },
        FUN.VALUE = character(1L),
        remoteDir = remoteDir,
        USE.NAMES = FALSE
    )
    stopifnot(goalie::allAreFiles(out))
    invisible(out)
}
