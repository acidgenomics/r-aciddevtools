.alert <- function(...) {
    stopifnot(requireNamespace("AcidCLI", quietly = TRUE))
    AcidCLI::alert(...)
}

.alertSuccess <- function(...) {
    stopifnot(requireNamespace("AcidCLI", quietly = TRUE))
    AcidCLI::alertSuccess(...)
}

.alertWarning <- function(...) {
    stopifnot(requireNamespace("AcidCLI", quietly = TRUE))
    AcidCLI::alertWarning(...)
}

.allAreDirs <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::allAreDirs(...)
}

.allAreSystemCommands <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::allAreSystemCommands(...)
}

.assert <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::assert(...)
}

.isADir <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isADir(...)
}

.isAFile <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isAFile(...)
}

.isASystemCommand <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isASystemCommand(...)
}

.isFlag <- function(...) {
    stopifnot(requireNamespace("goalie", quietly = TRUE))
    goalie::isFlag(...)
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
