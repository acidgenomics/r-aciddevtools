.alert <- function(...) {
    stopifnot(requireNamespace("AcidCLI", quietly = TRUE))
    AcidCLI::alert(...)
}

.alertWarning <- function(...) {
    stopifnot(requireNamespace("AcidCLI", quietly = TRUE))
    AcidCLI::alertWarning(...)
}

.allAreDirs <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::allAreDirs(...)
}

.assert <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::assert(...)
}

.isAFile <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isAFile(...)
}

.isASystemCommand <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isASystemCommand(...)
}

.isString <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isString(...)
}

.pasteURL <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::pasteURL(...)
}

.realpath <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::realpath(...)
}

.shell <- function(...) {
    stopifnot(requireNamespace("AcidBase", quietly = TRUE))
    AcidBase::shell(...)
}
