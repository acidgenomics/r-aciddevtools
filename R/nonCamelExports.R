#' Return exports that are not formatted in strict lower camel case
#'
#' @export
#' @note Updated 2023-09-27
#'
#' @inheritParams params
#'
#' @return `character`.
#' Names of exports that do not conform to strict lower camel case.
#'
#' @examples
#' x <- nonCamelExports()
#' print(x)
nonCamelExports <- function(path = getwd()) {
    stopifnot(
        .requireNamespaces("syntactic"),
        .isADir(path)
    )
    file <- file.path(path, "NAMESPACE")
    stopifnot(.isAFile(file))
    lines <- readLines(file)
    exports <- grep(pattern = "^export\\(", x = lines, value = TRUE)
    if (!.hasLength(exports)) {
        return(character())
    }
    x <- sub(
        pattern = "^export\\((.+)\\)$",
        replacement = "\\1",
        x = exports
    )
    y <- syntactic::camelCase(x)
    ok <- x == y
    if (all(ok)) {
        return(character())
    }
    out <- x[!ok]
    out
}
