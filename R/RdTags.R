#' R documentation tags
#'
#' Modified version of the unexported `tools:::RdTags` function.
#'
#' @export
#'
#' @inheritParams parseRd
#'
#' @examples
#' db <- tools::Rd_db("base")
#' Rd <- db[["nrow.Rd"]]
#' RdTags(Rd)

## Updated 2019-07-26.
RdTags <- function(object) {  # nolint
    assert(is(object, "Rd"))
    tags <- vapply(
        X = object,
        FUN = attr,
        FUN.VALUE = character(1L),
        "Rd_tag"
    )
    if (length(tags) == 0L) {
        tags <- character()
    } else {
        ## Remove the leading "\\" backslashes.
        tags <- gsub("^\\\\", "", tags)
    }
    tags
}
