#' Rebuild a binary tarball from a source tarball
#'
#' @export
#' @note Updated 2023-10-24.
#'
#' @param packageName `character`.
#' Package name(s).
#'
#' @param repo `character(1)`.
#' Drat repo directory path.
#'
#' @return Invisible output.
#'
#' @seealso
#' - `build()`.
#' - `publish()`.
#'
#' @examples
#' ## > rebuildBinary(c("AcidSingleCell", "DESeqAnalysis"))
rebuildBinary <-
    function(packageName,
             repo = file.path("~", "monorepo", "r-acidgenomics-com")) {
        stopifnot(
            .isCharacter(packageName),
            .isADir(repo)
        )
        invisible(lapply(
            X = packageName,
            repo = repo,
            FUN = function(packageName, repo) {
                contribDir <- file.path(repo, "src", "contrib")
                stopifnot(.isADir(contribDir))
                srcTarball <- sort(list.files(
                    path = contribDir,
                    pattern = packageName,
                    full.names = TRUE
                ))
                stopifnot(.isAFile(srcTarball))
                command <- file.path(R.home(), "bin", "R")
                tempdir <- .tempdir2()
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
                .unlink2(tempdir)
                out
            }
        ))
    }
