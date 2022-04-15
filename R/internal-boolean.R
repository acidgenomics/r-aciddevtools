## nocov start



#' Is a package installed?
#'
#' @note Updated 2020-08-11.
#' @noRd
#'
#' @param x `character`.
#' R package names.
#'
#' @param lib `character(1)` or `NULL`.
#' R package library.
#' If left `NULL`, checks all paths defined in `.libPaths`.
#'
#' @return `logical(1)`.
.isInstalled <- function(x, lib = NULL) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    df <- utils::installed.packages(lib.loc = lib)
    basename(x) %in% rownames(df)
}



#' Is the platform Linux?
#'
#' @note Updated 2021-04-30.
#' @noRd
#'
#' @return `logical(1)`.
#'
#' @seealso `goalie::isLinux`.
.isLinux <- function() {
    isTRUE(grepl(pattern = "linux", x = R.Version()[["os"]]))
}



#' Is the platform macOS?
#'
#' @note Updated 2021-04-30.
#' @noRd
#'
#' @return `logical(1)`.
#'
#' @seealso `goalie::isMacOS`.
.isMacOS <- function() {
    isTRUE(grepl(pattern = "darwin", x = R.Version()[["os"]]))
}



#' Is the current environment running in macOS R CRAN binary?
#'
#' @note Updated 2022-04-15.
#' @noRd
#'
#' @return `logical(1)`.
.isMacRCranBinary <- function() {
    isTRUE(grepl(
        pattern = paste0(
            "^",
            file.path(
                "",
                "Library",
                "Frameworks",
                "R.framework",
                "Resources"
            )
        ),
        x = Sys.getenv("R_HOME")
    ))
}



#' Does the macOS R CRAN binary have OpenMP enabled?
#'
#' @note Updated 2022-04-15.
#' @noRd
#'
#' @return `logical(1)`.
#'
#' @seealso
#' - https://mac.r-project.org/openmp/
.isMacOpenmpEnabled <- function() {
    all(file.exists(
        file.path(
            "", "usr", "local", "include",
            c("omp-tools.h", "omp.h", "ompt.h")
        ),
        file.path(
            "", "usr", "local", "lib", "libomp.dylib"
        )
    ))
}




## nocov end
