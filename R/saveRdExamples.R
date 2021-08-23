#' Save R documentation examples
#'
#' Parse the documentation for a function and save the working examples to an R
#' script. Note that the `f` argument is parameterized and can handle multiple
#' requests in a single call.
#'
#' @export
#' @note Updated 2021-08-23.
#'
#' @inheritParams params
#' @param rd `character` or `NULL`.
#'   R documentation name(s) from which to parse and save the working examples.
#'   If `NULL`, all documentation files containing examples will be saved.
#' @param package `character(1)`.
#'   Package name.
#'
#' @return Invisible `character`.
#' File path(s).
#'
#' @examples
#' dir <- file.path(tempdir(), "testdata")
#' out <- saveRdExamples(
#'     rd = c("do.call", "droplevels"),
#'     package = "base",
#'     dir = dir
#' )
#' print(out)
#' unlink(dir, recursive = TRUE)
saveRdExamples <- function(
    rd = NULL,
    package,
    dir = getwd()
) {
    stopifnot(
        requireNamespace("goalie", quietly = TRUE),
        requireNamespace("tools", quietly = TRUE),
        goalie::isCharacter(rd, nullOK = TRUE),
        goalie::isString(package),
        goalie::isString(dir)
    )
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    dir <- normalizePath(dir, mustWork = TRUE)
    ## Get a database of the Rd files available in the requested package.
    db <- tools::Rd_db(package)
    names(db) <- gsub("\\.Rd", "", names(db))
    ## If no Rd file is specified, save everything in package.
    if (is.null(rd)) {
        rd <- names(db)  # nolint
    }
    ## Check that the requiested function(s) are valid.
    stopifnot(all(rd %in% names(db)))
    ## Parse the rd files and return the working examples as a character.
    list <- mapply(
        rd = rd,
        MoreArgs = list(
            "package" = package,
            "dir" = dir
        ),
        FUN = function(rd, package, dir) {  # nolint
            x <- tryCatch(
                expr = parseRd(db[[rd]], tag = "examples"),
                error = function(e) character()
            )
            ## Early return if there are no examples.
            if (identical(length(x), 0L)) {
                message(sprintf("Skipped '%s'.", rd))
                return(invisible(NULL))
            }
            ## Save to an R script.
            path <- file.path(dir, paste0(rd, ".R"))
            unlink(path, recursive = FALSE)
            writeLines(text = x, con = path)
            path
        },
        SIMPLIFY = FALSE,
        USE.NAMES = TRUE
    )
    ## Coerce to character and remove NULL items.
    paths <- Filter(Negate(is.null), list)
    names <- names(paths)
    paths <- as.character(paths)
    names(paths) <- names
    message(sprintf(
        fmt = "Saved %d Rd examples from %s to '%s'.",
        length(paths), package, dir
    ))
    ## Return file paths of saved R scripts.
    invisible(paths)
}
