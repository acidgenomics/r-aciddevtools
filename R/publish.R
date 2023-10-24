#' Build packages and publish to Acid Genomics repo
#'
#' @export
#' @note Updated 2023-02-09.
#'
#' @section Building from the command line:
#'
#' ```sh
#' R CMD build ~/monorepo/r-packages/r-syntactic
#' R CMD INSTALL --build syntactic_0.5.2.tar.gz
#' R CMD check --as-cran syntactic_0.5.2.tar.gz
#' # How to install from source:
#' R CMD INSTALL syntactic_0.5.2.tar.gz
#' # Or how to install binary (on macOS).
#' R CMD INSTALL syntactic_0.5.2.tgz
#' ```
#'
#' @section Building vignettes:
#'
#' If you run into problems with a vignette index not being detected, make sure
#' the `.Rbuildignore` file does not contain `^vignettes$`. Ignoring `^Meta$`
#' and `^doc$` is acceptable though.
#'
#' Note that `devtools::build` currently doesn't handle building vignettes
#' for binary packages correctly.
#'
#' @param package `character`.
#' Directory paths to R package source code.
#' Vectorized, supporting the building of multiple packages in a single call.
#'
#' @param repo `character(1)`.
#' Directory path to local R repository (e.g. `"r-acidgenomics-com"`).
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
#' @param deploy `logical(1)`.
#' Deploy (push) the local repo to AWS S3.
#'
#' @return `logical(1)`.
#' Boolean, indicating if package build was successful.
#'
#' @seealso
#' - https://seandavi.github.io/post/build-linux-r-binary-packages/
#' - https://rstudio.github.io/r-manuals/r-exts/Creating-R-packages.html
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
    function(package = getwd(),
             repo = file.path("~", "monorepo", "r-acidgenomics-com"),
             check = TRUE,
             tag = TRUE,
             pkgdown = TRUE,
             deploy = TRUE) {
        stopifnot(
            .requireNamespaces(c("desc", "devtools")),
            .allAreSystemCommands(c("magick", "pandoc")),
            .allAreDirs(package),
            .isADir(repo),
            .isFlag(check),
            .isFlag(tag),
            .isFlag(pkgdown),
            .isFlag(deploy)
        )
        package <- .realpath(package)
        repo <- .realpath(repo)
        lapply(
            X = package,
            repo = repo,
            check = check,
            pkgdown = pkgdown,
            deploy = deploy,
            FUN = function(package, repo, check, pkgdown, deploy) {
                descFile <- file.path(package, "DESCRIPTION")
                stopifnot(.isAFile(descFile))
                if (isTRUE(check)) {
                    check(package)
                }
                if (isTRUE(pkgdown)) {
                    pkgdownDeployToAws(package = package)
                }
                tarballs <- build(package = package)
                invisible(Map(
                    file = tarballs,
                    MoreArgs = list("repo" = repo),
                    f = .insertPackage
                ))
                invisible(lapply(X = tarballs, FUN = file.remove))
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
                .shell(
                    command = "git",
                    args = c(
                        "checkout",
                        .gitDefaultBranch(repo = repo)
                    ),
                    wd = repo
                )
                .shell(
                    command = "git",
                    args = c("fetch", "--all"),
                    wd = repo
                )
                .shell(
                    command = "git",
                    args = "merge",
                    wd = repo
                )
                .shell(
                    command = "git",
                    args = c("add", "./"),
                    wd = repo
                )
                .shell(
                    command = "git",
                    args = c(
                        "commit", "-m",
                        paste0(
                            "'Add ",
                            basename(tarballs[["source"]]),
                            ".'"
                        )
                    ),
                    wd = repo
                )
                .shell(
                    command = "git",
                    args = "push",
                    wd = repo
                )
                message(sprintf(
                    "Successfully added '%s'.",
                    basename(tarballs[["source"]])
                ))
                TRUE
            }
        )
        if (isTRUE(deploy)) {
            message(sprintf(
                "Deploying packages to '%s'.",
                "r.acidgenomics.com"
            ))
            .shell(
                command = file.path(repo, "deploy"),
                wd = repo
            )
        }
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
