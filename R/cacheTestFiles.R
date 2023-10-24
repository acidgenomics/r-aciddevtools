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
#' @return Invisible `list`.
#' List containing `"cacheDir"`, `"files"`, and `"remoteDir"`.
cacheTestFiles <-
    function(pkg, files) {
        stopifnot(
            .hasInternet(),
            .isString(pkg),
            .isCharacter(files)
        )
        remoteDir <- .pasteUrl(
            "r.acidgenomics.com", "testdata", tolower(pkg),
            protocol = "https"
        )
        cacheDir <- .pkgCacheDir(pkg)
        cacheDir <- file.path(cacheDir, "testthat")
        cacheDir <- .initDir(cacheDir)
        files <- vapply(
            X = files,
            FUN = function(file, remoteDir) {
                destfile <- file.path(cacheDir, file)
                if (!.isAFile(destfile)) {
                    .download(
                        url = .pasteUrl(remoteDir, file),
                        destfile = destfile
                    )
                }
                destfile
            },
            FUN.VALUE = character(1L),
            remoteDir = remoteDir,
            USE.NAMES = FALSE
        )
        stopifnot(.allAreFiles(files))
        invisible(list(
            "cacheDir" = cacheDir,
            "files" = files,
            "remoteDir" = remoteDir
        ))
    }
