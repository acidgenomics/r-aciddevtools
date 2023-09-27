#' Parse R documentation
#'
#' Modified version of `tools:::.Rd_get_metadata()` that keeps whitespace and
#' returns `character` instead of `matrix`.
#'
#' @export
#' @note Updated 2023-09-25.
#'
#' @param object `Rd`.
#' R documentation, returned from `tools::Rd_db()`.
#'
#' @param tag `character(1)`.
#' Desired metadata type.
#'
#' These types are supported:
#'
#' - `title`.
#' - `description`.
#' - `usage`.
#' - `arguments`.
#' - `value`.
#' - `references`.
#' - `seealso`.
#' - `examples`.
#'
#' @seealso
#' - `tools::Rd_db()`.
#'
#' @examples
#' db <- tools::Rd_db("base")
#' head(names(db))
#' rd <- db[["nrow.Rd"]]
#' print(rdTags(rd))
#' examples <- parseRd(rd, tag = "examples")
#' print(examples)
parseRd <-
    function(object, tag) {
        stopifnot(
            .is(object, "Rd"),
            .isString(tag)
        )
        tags <- rdTags(object)
        stopifnot(.isSubset(tag, tags))
        ## Get the metadata that matches the requested tag.
        data <- object[tags == tag]
        data <- unlist(data, recursive = TRUE, use.names = FALSE)
        ## Strip trailing newlines and superfluous whitespace.
        data <- trimws(data, which = "right")
        ## Strip leading and trailing carriage returns, if present.
        if (identical(data[[1L]], "")) {
            data <- data[-1L]
        }
        if (identical(data[[length(data)]], "")) {
            data <- data[-length(data)] # nocov
        }
        data
    }



#' @describeIn parseRd
#' Modified version of the unexported `tools:::RdTags()` function.
#' @export
rdTags <- # nolint
    function(object) {
        stopifnot(.is(object, "Rd"))
        tags <- vapply(
            X = object,
            FUN = attr,
            FUN.VALUE = character(1L),
            "Rd_tag"
        )
        if (identical(length(tags), 0L)) {
            tags <- character() # nocov
        } else {
            ## Remove the leading "\\" backslashes.
            tags <- sub(pattern = "^\\\\", replacement = "", x = tags)
        }
        tags
    }
