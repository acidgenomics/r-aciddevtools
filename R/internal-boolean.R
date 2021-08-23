## nocov start



#' Is a package installed?
#'
#' @note Updated 2020-08-11.
#' @noRd
#'
#' @param x `character`.
#'   R package names.
#' @param lib `character(1)` or `NULL`.
#'   R package library.
#'   If left `NULL`, checks all paths defined in `.libPaths`.
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



## nocov end
