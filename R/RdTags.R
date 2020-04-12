#' R documentation tags
#'
#' Modified version of the unexported `tools:::RdTags` function.
#'
#' @export
#' @note Updated 2020-04-12.
#'
#' @inheritParams parseRd
#'
#' @examples
#' db <- tools::Rd_db("base")
#' Rd <- db[["nrow.Rd"]]
#' RdTags(Rd)
RdTags <- function(object) {  # nolint
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
    if (length(tags) == 0L) {
        tags <- character()
    } else {
        ## Remove the leading "\\" backslashes.
        tags <- gsub("^\\\\", "", tags)
    }
    tags
}
