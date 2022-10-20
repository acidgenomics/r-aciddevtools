#' Build source and binary packages
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @details
#' Files get built into temporary directory, defined in `tempdir()`.
#'
#' @param package `character`.
#' Directory path to R package.
#'
#' @seealso `R CMD build --help`.
#'
#' @return `character`.
#' Named character vector containing `binary` and `source` file paths.
#'
#' @examples
#' ## > package <- file.path("~", "monorepo", "r-packages", "r-goalie")
#' ## > build(package = package)
build <- function(package = getwd()) {
    stopifnot(
        .isADir(package),
        requireNamespace("desc", quietly = TRUE)
    )
    package <- .realpath(package)
    tempdir <- tempdir()
    descFile <- file.path(package, "DESCRIPTION")
    stopifnot(.isAFile(descFile))
    pkgName <- desc::desc_get_field(key = "Package", file = descFile)
    pkgVersion <- desc::desc_get_field(key = "Version", file = descFile)
    message(sprintf(
        "Building %s %s at '%s'.",
        pkgName, pkgVersion, tempdir
    ))
    buildArgs <- c("--log", "--md5")
    if (isTRUE(pkgName %in% "cgdsr")) {
        buildArgs <- append(
            x = buildArgs,
            values = c(
                "--no-build-vignettes",
                "--no-manual"
            )
        )
    }
    tarballs <- character()
    command <- file.path(R.home(), "bin", "R")
    message("Building source tarball.")
    .shell(
        command = command,
        args = c(
            "CMD", "build",
            buildArgs,
            package
        ),
        wd = tempdir
    )
    tarballs[["source"]] <-
        file.path(
            tempdir,
            paste0(pkgName, "_", pkgVersion, ".tar.gz")
        )
    stopifnot(.isAFile(tarballs[["source"]]))
    message("Building binary tarball.")
    .shell(
        command = command,
        args = c(
            "CMD", "INSTALL", "--build",
            tarballs[["source"]]
        ),
        wd = tempdir
    )
    tarballs[["binary"]] <-
        file.path(
            tempdir,
            paste0(pkgName, "_", pkgVersion, ".tgz")
        )
    stopifnot(.isAFile(tarballs[["binary"]]))
    if (isTRUE(file.size(tarballs[["source"]]) > 2e6L)) {
        stop(sprintf(
            "Source package is too large: '%s'.",
            tarballs[["source"]]
        ))
    }
    if (isTRUE(file.size(tarballs[["binary"]]) > 5e6L)) {
        stop(sprintf(
            "Binary package is too large: '%s'.",
            tarballs[["binary"]]
        ))
    }
    tarballs
}
