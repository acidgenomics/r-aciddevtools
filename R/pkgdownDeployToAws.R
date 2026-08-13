#' Deploy a pkgdown website to AWS S3 bucket
#'
#' @export
#' @note Updated 2026-07-28.
#'
#' @details
#' Deprecated in favor of `koopa app r publish-docs`, which builds the
#' pkgdown site and syncs it to the account-scoped R bucket resolved via
#' `koopa_s3_bucket("r")`, serving docs at `https://r.acidgenomics.com/<name>/`.
#' The old default `bucketDir` here pointed at the legacy
#' `s3://r.acidgenomics.com/packages/` bucket, which is no longer the live
#' origin for `r.acidgenomics.com` and was never actually being read by
#' visitors to the site.
#'
#' @param package `character`.
#' Directory path to R package.
#' Parameterized, supporting building of multiple package websites in
#' a single call.
#'
#' @param bucketDir `character(1)`.
#' Unused. Retained for backward compatibility only.
#'
#' @param clean `logical(1)`.
#' Unused. Retained for backward compatibility only.
#'
#' @return `logical`.
#' Whether individual pkgdown builds were successful, corresponding to
#' input defined in `package` argument.
#'
#' @examples
#' ## > pkgdownDeployToAws(
#' ## >     package = file.path("~", "monorepo", "r-packages", "r-koopa")
#' ## > )
pkgdownDeployToAws <-
    function(
        package = getwd(),
        bucketDir = "s3://r.acidgenomics.com/packages/",
        clean = TRUE
    ) {
        .Deprecated("koopa app r publish-docs")
        stopifnot(
            .requireNamespaces("desc"),
            .isASystemCommand("koopa"),
            .allAreDirs(package)
        )
        out <- vapply(
            X = .realpath(package),
            FUN = function(pkgDir) {
                descFile <- file.path(pkgDir, "DESCRIPTION")
                stopifnot(.isAFile(descFile))
                pkgName <-
                    desc::desc_get_field(key = "Package", file = descFile)
                configFile <- file.path(pkgDir, "_pkgdown.yml")
                if (!.isAFile(configFile)) {
                    message(sprintf(
                        "pkgdown not enabled for '%s' at '%s'.",
                        pkgName,
                        pkgDir
                    ))
                    return(invisible(FALSE))
                }
                message(sprintf(
                    "Publishing pkgdown website for '%s' at '%s'.",
                    pkgName,
                    pkgDir
                ))
                .shell(
                    command = "koopa",
                    args = c("app", "r", "publish-docs", pkgDir),
                    print = TRUE
                )
                TRUE
            },
            FUN.VALUE = logical(1L),
            USE.NAMES = FALSE
        )
        invisible(out)
    }
