#' Return documentation with arguments that are not formatted in strict lower
#' camel case
#'
#' @export
#' @note Updated 2023-09-27.
#'
#' @param pkgName `character(1)`.
#' Package name.
#'
#' @param allowlist `character`.
#' Character vector of common non-camel argument names to allow.
#'
#' @return `character`.
#' Offending Rd documentation files.
nonCamelArgs <-
    function(pkgName,
             allowlist = c("BPPARAM", "FUN", "MARGIN", "USE.NAMES", "X", "do.NULL")) {
        stopifnot(
            .requireNamespaces(c("syntactic", "tools")),
            .isString(pkgName),
            is.character(allowlist)
        )
        allowlist <- c(allowlist, "\n", "...")
        db <- tools::Rd_db(pkgName)
        lst <- lapply(
            X = db,
            allowlist = allowlist,
            FUN = function(rd, allowlist) {
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
                vec <- setdiff(vec, allowlist)
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
        lst <- lapply(
            X = lst,
            FUN = function(x) {
                ## Split combined arguments, when necessary.
                if (any(grepl(pattern = ", ", x = x))) {
                    x <- unique(unlist(strsplit(x, split = ", ")))
                }
                ## Ignore leading "." on arguments, such as ".xname".
                x <- sub(pattern = "^\\.", replacement = "", x = x)
                y <- syntactic::camelCase(x)
                x[x != y]
            }
        )
        lst <- Filter(.hasLength, lst)
        out <- paste(
            names(lst),
            lapply(X = lst, FUN = toString),
            sep = ": "
        )
        out
    }
