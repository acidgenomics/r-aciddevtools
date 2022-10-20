## nocov start



#' Does the input contain any duplicates?
#'
#' @note Updated 2022-10-20.
#' @noRd
#'
#' @param x Object.
#'
#' @return `logical(1)`.
.hasDuplicates <- function(x) {
    anyDuplicated(x) > 0L
}



#' Is the input a boolean flag?
#'
#' @note Updated 2022-10-20.
#' @noRd
#'
#' @param x Object.
#'
#' @return `logical(1)`.
.isFlag <- function(x) {
    is.logical(x) && .isScalar(x)
}



#' Is a package installed?
#'
#' @note Updated 2022-10-20.
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
    basename(x) %in% .packages(all.available = TRUE, lib.loc = lib)
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



#' Is the current environment running in macOS R CRAN binary framework?
#'
#' @note Updated 2022-04-28.
#' @noRd
#'
#' @return `logical(1)`.
.isMacosFramework <- function() {
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



#' Is the input scalar?
#'
#' @note Updated 2022-10-20.
#' @noRd
#'
#' @param x Object.
#'
#' @return `logical(1)`.
.isScalar <- function(x) {
    identical(length(x), 1L)
}



#' Is the input a character string?
#'
#' @note Updated 2022-10-20.
#' @noRd
#'
#' @param x Object.
#'
#' @return `logical(1)`.
.isString <- function(x) {
    is.character(x) && .isScalar(x)
}



## nocov end
