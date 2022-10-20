#' Deploy a pkgdown website to AWS S3 bucket
#'
#' @export
#' @note Updated 2022-10-20.
#'
#' @param package `character`.
#' Directory path to R package.
#' Parameterized, supporting building of multiple package websites in
#' a single call.
#'
#' @param bucketDir `character(1)`.
#' AWS S3 bucket path.
#'
#' @param clean `logical(1)`.
#' Ensure pkgdown website build is clean, and also deleted after upload
#' to AWS S3.
#'
#' @return `logical`.
#' Whether individual pkgdown builds were successful, corresponding to
#' input defined in `package` argument.
#'
#' @examples
#' ## > pkgdownDeployToAWS(
#' ## >     package = file.path("~", "monorepo", "r-packages", "r-koopa")
#' ## > )
pkgdownDeployToAWS <-
    function(package = getwd(),
             bucketDir = "s3://r.acidgenomics.com/packages/",
             clean = TRUE) {
        stopifnot(
            .requireNamespaces(c("desc", "pkgdown")),
            .isASystemCommand("aws"),
            .allAreDirs(package),
            .isString(bucketDir)
        )
        bucketDir <- sub(
            pattern = "/$",
            replacement = "",
            x = bucketDir
        )
        out <- vapply(
            X = .realpath(package),
            FUN = function(pkgDir) {
                descFile <- file.path(pkgDir, "DESCRIPTION")
                stopifnot(.isAFile(descFile))
                pkgName <-
                    desc::desc_get_field(key = "Package", file = descFile)
                bucketDir <- .pasteURL(bucketDir, tolower(pkgName))
                docsDir <- file.path(pkgDir, "docs")
                configFile <- file.path(pkgDir, "_pkgdown.yml")
                if (!.isAFile(configFile)) {
                    message(sprintf(
                        "pkgdown not enabled for '%s' at '%s'.",
                        pkgName, pkgDir
                    ))
                    return(invisible(FALSE))
                }
                message(sprintf(
                    paste(
                        "Building pkgdown website for '%s' at '%s',",
                        "then pushing to AWS S3 bucket at '%s'."
                    ),
                    pkgName, docsDir, bucketDir
                ))
                if (isTRUE(clean)) {
                    unlink(docsDir, recursive = TRUE)
                }
                build_site(pkg = pkgDir)
                ## FIXME The message is inconsistent here. Our local directory
                ## is not escaped with single quotes, but the AWS S3 bucket
                ## is currently. Need to rework in AcidBase?
                .shell(
                    command = "aws",
                    args = c(
                        "--profile", "acidgenomics",
                        "s3", "sync", "--delete",
                        paste0(docsDir, "/"),
                        paste0(bucketDir, "/")
                    ),
                    print = TRUE
                )
                if (isTRUE(clean)) {
                    unlink(docsDir, recursive = TRUE)
                }
                TRUE
            },
            FUN.VALUE = logical(1L),
            USE.NAMES = FALSE
        )
        invisible(out)
    }
