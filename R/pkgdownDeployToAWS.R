## FIXME Move this to AcidDevTools.
## FIXME Need to rework in base R.



#' Deploy a pkgdown website to AWS S3 bucket
#'
#' @export
#' @note Updated 2022-04-29.
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
        .assert(
            requireNamespace("desc", quietly = TRUE),
            requireNamespace("pkgdown", quietly = TRUE),
            .isASystemCommand("aws"),
            .allAreDirs(package),
            .isString(bucketDir)
        )
        # FIXME Need to strip trailing slash of S3 bucket here...
        out <- vapply(
            X = .realpath(package),
            FUN = function(pkgDir) {
                descFile <- file.path(pkgDir, "DESCRIPTION")
                .assert(.isAFile(descFile))
                pkgName <-
                    desc::desc_get_field(key = "Package", file = descFile)
                bucketDir <- .pasteURL(bucketDir, tolower(pkgName))
                docsDir <- file.path(pkgDir, "docs")
                configFile <- file.path(pkgDir, "_pkgdown.yml")
                if (!.isAFile(configFile)) {
                    .alertWarning(sprintf(
                        "pkgdown not enabled for {.pkg %s} at {.path %s}.",
                        pkgName, pkgDir
                    ))
                    return(invisible(FALSE))
                }
                .alert(sprintf(
                    paste(
                        "Building pkgdown website for {.pkg %s} at {.path %s},",
                        "then pushing to AWS S3 bucket at {.url %s}."
                    ),
                    pkgName, docsDir, bucketDir
                ))
                if (isTRUE(clean)) {
                    unlink(docsDir, recursive = TRUE)
                }
                pkgdown::build_site(pkg = pkgDir)
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
