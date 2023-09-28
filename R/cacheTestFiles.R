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
    cacheDir <- file.path(AcidBase::pkgCacheDir(.pkgName), "testthat")
    AcidBase::initDir(cacheDir)
    out <- unlist(Map(
        f = function(file, remoteDir, envir) {
            destfile <- file.path(cacheDir, file)
            if (!goalie::isAFile(destfile)) {
                AcidBase::download(
                    url = AcidBase::pasteUrl(remoteDir, file),
                    destfile = destfile
                )
            }
            destfile
        },
        file = files,
        MoreArgs = list("remoteDir" = remoteDir)
    ))
    stopifnot(goalie::allAreFiles(out))
    invisible(out)
}
