#' Parse R documentation
#'
#' Modified version of `tools:::.Rd_get_metadata()` that keeps whitespace and
#' returns `character` instead of `matrix`.
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @param object `Rd`.
#'   R documentation, returned from [tools::Rd_db()]
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
#' @seealso [tools::Rd_db()].
#'
#' @examples
#' db <- tools::Rd_db("base")
#' head(names(db))
#' Rd <- db[["nrow.Rd"]]
#' class(Rd)
#' summary(Rd)
#' RdTags(Rd)
#' examples <- parseRd(Rd, tag = "examples")
#' print(examples)
parseRd <- function(object, tag) {
    assert(
        is(object, "Rd"),
        isString(tag)
    )
    tags <- RdTags(object)
    assert(all(tag %in% tags))
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
