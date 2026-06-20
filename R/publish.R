#' Build packages and publish to Acid Genomics repo
#'
#' @export
#' @note Updated 2026-06-20.
#'
#' @details
#' Delegates build, drat insert, S3 sync, and CloudFront invalidation to
#' `koopa app r publish`. Optional package checks and pkgdown site deployment
#' are handled in R before handing off to koopa.
#'
#' @param package `character`.
#' Directory paths to R package source code.
#' Vectorized, supporting the building of multiple packages in a single call.
#'
#' @param check `logical(1)`.
#' Perform package checks prior to building package.
#'
#' @param tag `logical(1)`.
#' Tag release on GitHub.
#'
#' @param pkgdown `logical(1)`.
#' Build pkgdown website, if supported.
#'
#' @return `logical(1)`.
#' Boolean, indicating if package build was successful.
#'
#' @examples
#' ## > publish(
#' ## >     package = file.path(
#' ## >         "~",
#' ## >         "monorepo",
#' ## >         "r-packages",
#' ## >         c(
#' ## >             "r-acidbase",
#' ## >             "r-basejump",
#' ## >             "r-koopa"
#' ## >         )
#' ## >     )
#' ## > )
publish <-
    function(
        package = getwd(),
        check = TRUE,
        tag = TRUE,
        pkgdown = TRUE
    ) {
        stopifnot(
            .requireNamespaces(c("desc", "devtools")),
            .allAreSystemCommands(c("koopa", "magick", "pandoc")),
            .allAreDirs(package),
            .isFlag(check),
            .isFlag(tag),
            .isFlag(pkgdown)
        )
        package <- .realpath(package)
        lapply(
            X = package,
            check = check,
            pkgdown = pkgdown,
            FUN = function(package, check, pkgdown) {
                descFile <- file.path(package, "DESCRIPTION")
                stopifnot(.isAFile(descFile))
                if (isTRUE(check)) {
                    check(package)
                }
                if (isTRUE(pkgdown)) {
                    pkgdownDeployToAws(package = package)
                }
                koopa_args <- c("app", "r", "publish", package, "--no-check")
                message(sprintf(
                    "Running: koopa %s",
                    paste(koopa_args, collapse = " ")
                ))
                .shell(command = "koopa", args = koopa_args, wd = package)
                if (isTRUE(tag)) {
                    message("Tagging on GitHub.")
                    name <-
                        desc::desc_get_field(key = "Package", file = descFile)
                    version <-
                        as.character(desc::desc_get_version(file = descFile))
                    today <- Sys.Date()
                    .shell(
                        command = "git",
                        args = c("fetch", "--force", "--tags"),
                        wd = package
                    )
                    .shell(
                        command = "git",
                        args = c(
                            "push",
                            "origin",
                            paste(
                                .gitCurrentBranch(),
                                .gitDefaultBranch(),
                                sep = ":"
                            )
                        ),
                        wd = package
                    )
                    .shell(
                        command = "git",
                        args = c(
                            "tag",
                            "--force",
                            "-a",
                            paste0("'v", version, "'"),
                            "-m",
                            paste0("'", name, " v", version, " (", today, ")'")
                        ),
                        wd = package
                    )
                    .shell(
                        command = "git",
                        args = c("push", "--force", "--tags"),
                        wd = package
                    )
                }
                invisible(TRUE)
            }
        )
        invisible(TRUE)
    }


#' Insert a package into drat repository
#'
#' @note Updated 2023-10-24.
#' @noRd
.insertPackage <- function(file, repo) {
    stopifnot(
        requireNamespace("drat", quietly = TRUE),
        .isAFile(file),
        .isADir(repo)
    )
    drat::insertPackage(
        file = file,
        "repodir" = repo,
        "action" = "none",
        # Additional `write_PACKAGES` options.
        "verbose" = FALSE,
        "unpacked" = FALSE,
        "subdirs" = FALSE,
        "latestOnly" = TRUE,
        "addFiles" = FALSE,
        "rds_compress" = "xz",
        "validate" = TRUE
    )
}
