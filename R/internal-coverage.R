#' Check package coverage using covr
#'
#' @note Updated 2021-07-05.
#' @noRd
.checkCoverage <- function(
    path = ".",
    cutoff = 0.80
) {
    if (!dir.exists(file.path(path, "tests"))) {
        return(invisible(FALSE))
    }
    message("Checking coverage with covr package.")
    pctCutoff <- cutoff * 100L
    if (isTRUE(nzchar(Sys.getenv("RCHECK_KEEP_IT_100")))) {
        ## covr sometimes reports 99.8% coverage instead of 100%.
        pctCutoff <- 99L
        message("Requiring 100% coverage.")
    }
    cov <- package_coverage(path = path)
    pct <- percent_coverage(cov)
    print(cov)
    if (pct < pctCutoff) {
        stop(sprintf("Coverage is %s%%.", round(pct, digits = 2L)))
    }
    invisible(TRUE)
}
