#' Parse R documentation
#'
#' Modified version of `tools:::.Rd_get_metadata()` that keeps whitespace and
#' returns `character` instead of `matrix`.
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @param object `Rd`.
#'   R documentation, returned from `tools::Rd_db()`.
#' @param tag `character(1)`.
#'   Desired metadata type.
#'
#'   These types are supported:
#'
#'   - `title`.
#'   - `description`.
#'   - `usage`.
#'   - `arguments`.
#'   - `value`.
#'   - `references`.
#'   - `seealso`.
#'   - `examples`.
#'
#' @seealso `tools::Rd_db()`.
#'
#' @examples
#' db <- tools::Rd_db("base")
#' head(names(db))
#' rd <- db[["nrow.Rd"]]
#' class(rd)
#' summary(rd)
#' RdTags(rd)
#' examples <- parseRd(rd, tag = "examples")
#' print(examples)
parseRd <-
    function(object, tag) {
        stopifnot(
            requireNamespace("methods", quietly = TRUE),
            methods::is(object, "Rd"),
            is.character(tag) && identical(length(tag), 1L)
        )
        tags <- RdTags(object)
        stopifnot(all(tag %in% tags))
        ## Get the metadata that matches the requested tag.
        data <- object[tags == tag]
        data <- unlist(data)
        ## Strip trailing newlines and superfluous whitespace.
        data <- trimws(data, which = "right")
        ## Strip leading and trailing carriage returns, if present.
        if (data[[1L]] == "") {
            data <- data[-1L]
        }
        if (data[[length(data)]] == "") {
            data <- data[-length(data)]
        }
        data
    }



#' @describeIn parseRd
#'   Modified version of the unexported `tools:::RdTags()` function.
#' @export
RdTags <-  # nolint
    function(object) {
        stopifnot(
            requireNamespace("methods", quietly = TRUE),
            methods::is(object, "Rd")
        )
        tags <- vapply(
            X = object,
            FUN = attr,
            FUN.VALUE = character(1L),
            "Rd_tag"
        )
        if (identical(length(tags), 0L)) {
            tags <- character()
        } else {
            ## Remove the leading "\\" backslashes.
            tags <- gsub("^\\\\", "", tags)
        }
        tags
    }
