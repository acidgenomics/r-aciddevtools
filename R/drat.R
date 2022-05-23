#' Build packages and commit to drat repo
#'
#' @export
#' @note Updated 2022-05-02.
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
#' Directory path to local R drat repository (e.g. `"r-acidgenomics-com"`).
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
#' Deploy (push) the drat repo to AWS S3.
#'
#' @return `logical(1)`.
#' Boolean, indicating if drat build was successful.
#'
#' @seealso
#' - https://seandavi.github.io/post/build-linux-r-binary-packages/
#' - https://rstudio.github.io/r-manuals/r-exts/Creating-R-packages.html
#'
#' @examples
#' ## > drat(
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
drat <-
    function(package = getwd(),
             repo = file.path("~", "monorepo", "r-acidgenomics-com"),
             check = TRUE,
             tag = TRUE,
             pkgdown = TRUE,
             deploy = TRUE) {
        .assert(
            requireNamespace("desc", quietly = TRUE),
            requireNamespace("devtools", quietly = TRUE),
            .allAreSystemCommands(c("magick", "pandoc")),
            .allAreDirs(package),
            .isADir(repo),
            .isFlag(check),
            .isFlag(tag),
            .isFlag(pkgdown),
            .isFlag(deploy)
        )
        package <- .realpath(package)
        wd <- getwd()
        lapply(
            X = package,
            repo = repo,
            check = check,
            pkgdown = pkgdown,
            deploy = deploy,
            FUN = function(package, repo, check, pkgdown, deploy) {
                descFile <- file.path(package, "DESCRIPTION")
                .assert(.isAFile(descFile))
                if (isTRUE(check)) {
                    check(package)
                }
                if (isTRUE(pkgdown)) {
                    pkgdownDeployToAWS(package)
                }
                tarballs <- build(package)
                mapply(
                    file = tarballs,
                    MoreArgs = list(
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
                    ),
                    FUN = drat::insertPackage,
                    SIMPLIFY = FALSE
                )
                invisible({
                    lapply(X = tarballs, FUN = file.remove)
                })
                if (isTRUE(tag)) {
                    .alert("Tagging on GitHub.")
                    setwd(package)
                    name <-
                        desc::desc_get_field(key = "Package", file = descFile)
                    version <-
                        as.character(desc::desc_get_version(file = descFile))
                    today <- Sys.Date()
                    .shell(
                        command = "git",
                        args = c("fetch", "--force", "--tags")
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
                        )
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
                        )
                    )
                    .shell(
                        command = "git",
                        args = c("push", "--force", "--tags")
                    )
                }
                setwd(repo)
                .shell(
                    command = "git",
                    args = c("checkout", .gitDefaultBranch())
                )
                .shell(
                    command = "git",
                    args = c("fetch", "--all")
                )
                .shell(
                    command = "git",
                    args = "merge"
                )
                .shell(
                    command = "git",
                    args = c("add", "./")
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
                    )
                )
                .shell(
                    command = "git",
                    args = "push"
                )
                setwd(wd)
                .alertSuccess(sprintf(
                    "Successfully added {.file %s}.",
                    basename(tarballs[["source"]])
                ))
                TRUE
            }
        )
        if (isTRUE(deploy)) {
            .alert(sprintf(
                "Deploying packages to {.var %s}.",
                "r.acidgenomics.com"
            ))
            setwd(repo)
            .assert(.isAFile("deploy"))
            .shell(command = "./deploy")
            setwd(wd)
        }
        invisible(TRUE)
    }
