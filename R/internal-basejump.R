## FIXME Internalize this.

#' @seealso goalie::allAreDirs
#' @noRd
.allAreDirs <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::allAreDirs(...)
}



#' @seealso goalie::allAreSystemCommands
#' @noRd
.allAreSystemCommands <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::allAreSystemCommands(...)
}



#' @seealso AcidBase::gitCurrentBranch
#' @noRd
.gitCurrentBranch <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::gitCurrentBranch(...)
}



#' @seealso AcidBase::gitDefaultBranch
#' @noRd
.gitDefaultBranch <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
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



#' @seealso goalie::isFlag
#' @noRd
.isFlag <- function(x) {
    is.logical(x) && .isScalar(x)
}



#' @seealso goalie::isAGitRepo
#' @noRd
.isAGitRepo <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isAGitRepo(...)
}



#' @seealso goalie::isASystemCommand
#' @noRd
.isASystemCommand <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
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



#' @seealso goalie::isMacOS
#' @noRd
.isMacOS <- function() {
    isTRUE(grepl(pattern = "darwin", x = R.Version()[["os"]]))
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



#' @seealso AcidBase::pasteURL
#' @noRd
.pasteURL <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::pasteURL(...)
}



#' @seealso AcidBase::realpath
#' @noRd
.realpath <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::realpath(...)
}



#' @seealso AcidBase::requireNamespaces
#' @noRd
.requireNamespaces <- function(packages) {
    ok <- vapply(
        X = packages,
        FUN = requireNamespace,
        FUN.VALUE = logical(1L),
        USE.NAMES = TRUE,
        quietly = TRUE
    )
    if (!isTRUE(all(ok))) {
        fail <- names(ok)[!ok]
        stop(sprintf(
            fmt = "%s not installed: %s.",
            ngettext(n = length(fail), msg1 = "Package", msg2 = "Packages"),
            toString(fail)
        ))
    }
    invisible(TRUE)
}



#' @seealso AcidBase::shell
#' @noRd
.shell <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::shell(...)
}
