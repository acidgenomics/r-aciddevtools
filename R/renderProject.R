#' Render All R Markdown Files in Working Directory
#'
#' @param today Render to a subdirectory with today's date.
#'
#' @return No value.
#' @export
renderProject <- function(today = TRUE) {
    if (identical(getwd(), Sys.getenv("HOME"))) {
        stop("Working from HOME directory")
    }
    if (!length(list.files(pattern = "\\.Rproj$"))) {
        warning("No Rproj file found")
    }

    if (isTRUE(today)) {
        outputDir <- Sys.Date()
        dir.create(outputDir, showWarnings = FALSE)
    } else {
        outputDir <- getwd()
    }

    # Get the list of RMarkdown files
    files <- list.files(pattern = "\\.Rmd$") %>%
        # Ignore drafts
        .[!grepl("_draft\\.Rmd$", ., ignore.case = TRUE)] %>%
        # Ignore child chunk files
        .[!grepl("(footer|header)\\.Rmd$", .)]
    if (!length(files)) {
        message("No RMarkdown files to render")
        return(invisible())
    }

    invisible(lapply(
        X = files,
        FUN = function(input) {
            render(
                input,
                clean = TRUE,
                envir = new.env(),
                knit_root_dir = getwd(),
                output_dir = outputDir,
                output_format = "all"
            )
        }
    ))
}
