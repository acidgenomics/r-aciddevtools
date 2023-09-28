#' Return exports that are not formatted in strict camel case
#'
#' @export
#' @note Updated 2023-09-28.
#'
#' @inheritParams params
#'
#' @return `character`.
#' Names of exports that do not conform to strict camel case.
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
    x <- readLines(file)
    x <- grep(pattern = "^export(Classes|Methods)?\\(", x = x, value = TRUE)
    if (!.hasLength(x)) {
        return(character())
    }
    x <- sub(
        pattern = "^export(Classes|Methods)?\\((.+)\\)$",
        replacement = "\\2",
        x = x
    )
    ## Ignore non-alphanumeric functions, such as "[".
    x <- x[!grepl(pattern = "^\"[^a-zA-Z0-9.]\"", x = x)]
    ## Sanitize leading "." which normally shouldn't be exported anyway.
    x <- sub(pattern = "^\\.", replacement = "", x = x)
    ## Sanitize assignment methods.
    x <- sub(pattern = "^\"(.+)<-\"$", replacement = "\\1", x = x)
    ## Ignore coercion methods (e.g. "as.DataFrame").
    x <- x[!grepl(pattern = "^as\\.", x = x)]
    ## Ignore all uppercase exports (e.g. "HGNC", "MGI").
    ## > x <- x[!grepl(pattern = "^[A-Z0-9]+$", x = x)]
    x <- sort(unique(x))
    subx <- substr(x, start = 1L, stop = 1L)
    case <- list()
    case[["lower"]] <- subx == tolower(subx)
    case[["upper"]] <- !case[["lower"]]
    fail <- character()
    if (any(case[["upper"]])) {
        xx <- x[case[["upper"]]]
        xx <- xx[xx != syntactic::upperCamelCase(xx)]
        if (.hasLength(xx)) {
            fail <- append(fail, xx)
        }
    }
    if (any(case[["lower"]])) {
        xx <- x[case[["lower"]]]
        xx <- xx[xx != syntactic::camelCase(xx)]
        if (.hasLength(xx)) {
            fail <- append(fail, xx)
        }
    }
    fail
}
