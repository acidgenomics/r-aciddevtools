#' Check package coverage using covr
#'
#' @note Updated 2022-10-20.
#' @noRd
.checkCoverage <- function(path = getwd(), cutoff = 0.9) {
    if (!dir.exists(file.path(path, "tests"))) {
        return(invisible(FALSE))
    }
    path <- .realpath(path)
    message(sprintf(
        "Checking coverage in '%s' with %s package.",
        path,
        "covr"
    ))
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
        stop(sprintf(
            "Coverage in '%s' is %s%%.",
            path,
            round(pct, digits = 2L)
        ))
    }
    invisible(TRUE)
}
