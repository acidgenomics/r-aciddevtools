#' Build source and binary packages
#'
#' @export
#' @note Updated 2022-04-30.
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
    .assert(
        .isADir(package),
        requireNamespace("desc", quietly = TRUE)
    )
    package <- .realpath(package)
    wd <- getwd()
    tempdir <- tempdir()
    setwd(tempdir)
    descFile <- file.path(package, "DESCRIPTION")
    .assert(.isAFile(descFile))
    pkgName <- desc::desc_get_field(key = "Package", file = descFile)
    pkgVersion <- desc::desc_get_field(key = "Version", file = descFile)
    .alert(sprintf(
        "Building {.pkg %s} %s at {.dir %s}.",
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
    .alert("Building source tarball.")
    .shell(
        command = command,
        args = c(
            "CMD", "build",
            buildArgs,
            package
        )
    )
    tarballs[["source"]] <-
        file.path(
            tempdir,
            paste0(pkgName, "_", pkgVersion, ".tar.gz")
        )
    .assert(.isAFile(tarballs[["source"]]))
    .alert("Building binary tarball.")
    .shell(
        command = command,
        args = c(
            "CMD", "INSTALL", "--build",
            tarballs[["source"]]
        )
    )
    tarballs[["binary"]] <-
        file.path(
            tempdir,
            paste0(pkgName, "_", pkgVersion, ".tgz")
        )
    .assert(.isAFile(tarballs[["binary"]]))
    if (isTRUE(file.size(tarballs[["source"]]) > 2e6L)) {
        .abort(sprintf(
            "Source package is too large: {.file %s}.",
            tarballs[["source"]]
        ))
    }
    if (isTRUE(file.size(tarballs[["binary"]]) > 3e6L)) {
        .abort(sprintf(
            "Binary package is too large: {.file %s}.",
            tarballs[["binary"]]
        ))
    }
    setwd(wd)
    tarballs
}
