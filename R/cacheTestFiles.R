#' Cache test files from Acid Genomics S3 bucket
#'
#' @export
#' @note Updated 2023-09-28.
#'
#' @param pkg `character(1)`.
#' Package name.
#'
#' @param files `character`.
#' File names in S3 testdata bucket.
#'
#' @return Invisible `character`.
#' File paths.
cacheTestFiles <-
    function(pkg, files) {
        stopifnot(
            .requireNamespaces(c("AcidBase", "goalie")),
            goalie::hasInternet(),
            goalie::isString(pkg),
            goalie::isCharacter(files)
        )
        remoteDir <- AcidBase::pasteURL(
            "r.acidgenomics.com", "testdata", tolower(pkg),
            protocol = "https"
        )
        stopifnot(goalie::isAnExistingUrl(remoteDir))
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
