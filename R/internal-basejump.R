#' @seealso goalie::allAreDirs
#' @noRd
.allAreDirs <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::allAreDirs(...)
}



#' @seealso goalie::allAreSystemCommands
#' @noRd
.allAreSystemCommands <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::allAreSystemCommands(...)
}



#' @seealso AcidBase::gitCurrentBranch
#' @noRd
.gitCurrentBranch <- function(...) {
    stopifnot(.requireNamespaces("AcidBase"))
    AcidBase::gitCurrentBranch(...)
}



#' @seealso AcidBase::gitDefaultBranch
#' @noRd
.gitDefaultBranch <- function(...) {
    stopifnot(.requireNamespaces("AcidBase"))
    AcidBase::gitDefaultBranch(...)
}



#' @seealso goalie::hasDuplicates
#' @noRd
.hasDuplicates <- function(x) {
    anyDuplicated(x) > 0L
}



#' @seealso goalie::hasNoDuplicates
#' @noRd
.hasNoDuplicates <- function(x) {
    identical(anyDuplicated(x), 0L)
}



#' @seealso goalie::hasLength
#' @noRd
.hasLength <- function(x) {
    length(x) > 0L
}



#' @seealso methods::is
#' @noRd
.is <- function(...) {
    stopifnot(.requireNamespaces("methods"))
    methods::is(...)
}



#' @seealso goalie::isADir
#' @noRd
.isADir <- function(x) {
    .isString(x) && dir.exists(x)
}



#' @seealso goalie::isAFile
#' @noRd
.isAFile <- function(x) {
    .isString(x) && file.exists(x)
}



#' @seealso goalie::isAny
#' @noRd
.isAny <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::isAny(...)
}



#' @seealso goalie::isFlag
#' @noRd
.isFlag <- function(x) {
    is.logical(x) && .isScalar(x)
}



#' @seealso goalie::isAGitRepo
#' @noRd
.isAGitRepo <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::isAGitRepo(...)
}



#' @seealso goalie::isASystemCommand
#' @noRd
.isASystemCommand <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::isASystemCommand(...)
}



#' @seealso goalie::isInstalled
#' @noRd
.isInstalled <- function(x, lib = NULL) {
    basename(x) %in% .packages(all.available = TRUE, lib.loc = lib)
}



#' @seealso goalie::isLinux
#' @noRd
.isLinux <- function() {
    isTRUE(grepl(pattern = "linux", x = R.Version()[["os"]]))
}



#' @seealso goalie::isMacos
#' @noRd
.isMacos <- function() {
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



#' @seealso goalie::isRStudio
#' @noRd
.isRStudio <- function(...) {
    stopifnot(.requireNamespaces("goalie"))
    goalie::isRStudio(...)
}



#' @seealso goalie::isScalar
#' @noRd
.isScalar <- function(x) {
    identical(length(x), 1L)
}



#' @seealso goalie::isString
#' @noRd
.isString <- function(x) {
    is.character(x) && .isScalar(x)
}



#' @seealso goalie::isSubset
#' @noRd
.isSubset <- function(x, y) {
    all(x %in% y)
}



#' @seealso AcidBase::pasteUrl
#' @noRd
.pasteUrl <- function(...) {
    stopifnot(.requireNamespaces("AcidBase"))
    AcidBase::pasteUrl(...)
}



#' @seealso AcidBase::realpath
#' @noRd
.realpath <- function(...) {
    stopifnot(.requireNamespaces("AcidBase"))
    AcidBase::realpath(...)
}



#' @seealso goalie::requireNamespaces
#' @noRd
.requireNamespaces <- function(packages) {
    ok <- all(vapply(
        X = packages,
        FUN = requireNamespace,
        FUN.VALUE = logical(1L),
        USE.NAMES = TRUE,
        quietly = TRUE
    ))
    invisible(ok)
}



#' @seealso AcidBase::shell
#' @noRd
.shell <- function(...) {
    stopifnot(.requireNamespaces("AcidBase"))
    AcidBase::shell(...)
}
