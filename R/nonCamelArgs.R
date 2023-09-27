#' Return documentation with arguments that are not formatted in strict lower
#' camel case
#'
#' @export
#' @note Updated 2023-09-27.
#'
#' @param pkgName `character(1)`.
#' Package name.
#'
#' @return `character`.
#' Offending Rd documentation files.
nonCamelArgs <- function(pkgName) {
    stopifnot(.requireNamespaces(c("syntactic", "tools")))
    db <- tools::Rd_db(pkgName)
    lst <- lapply(
        X = db,
        FUN = function(rd) {
            tag <- "arguments"
            tags <- rdTags(rd)
            if (!.isSubset(tag, tags)) {
                return(NULL)
            }
            data <- rd[which(tags == tag)][[1L]]
            vec <- vapply(
                X = data,
                FUN = function(x) {
                    x[[1L]][[1L]]
                },
                FUN.VALUE = character(1L)
            )
            vec <- setdiff(vec, c("\n", "..."))
            if (identical(vec, tolower(vec))) {
                return(NULL)
            }
            vec
        }
    )
    lst <- Filter(Negate(is.null), lst)
    if (!.hasLength(lst)) {
        return(character())
    }
    ok <- vapply(
        X = lst,
        FUN = function(x) {
            y <- syntactic::camelCase(x)
            identical(x, y)
        },
        FUN.VALUE = logical(1L),
        USE.NAMES = FALSE
    )
    lst <- lst[!ok]
    out <- names(lst)
    out
}
