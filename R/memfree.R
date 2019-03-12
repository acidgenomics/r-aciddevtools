#' Get free memory statistics.
#'
#' @note Currently this only works for Linux.
#'
#' @export
#'
#' @seealso
#' - `help(topic = "Memory", package = "base")`.
#' - `help(topic = "Memory-limits", package = "base")`.
#' - `utils:::format.object_size()`.
#' - `print:::print.bytes()`.
#' - https://stackoverflow.com/a/6457769
#' - https://stackoverflow.com/a/29787527
#' - https://stat.ethz.ch/R-manual/R-devel/library/base/html/Memory-limits.html
#' - http://adv-r.had.co.nz/memory.html
memfree <- function() {
    message("Running garbage collection first with base::gc().")
    print(gc(verbose = TRUE, full = TRUE))
    mem_used <- capture.output(print(pryr::mem_used()))
    mem_free <- utils:::format.object_size(as.numeric(
        system("awk '/MemFree/ {print $2}' /proc/meminfo", intern = TRUE)
    ), "auto")
    message(paste0(
        "Memory used: ", mem_used, " (pryr::mem_used)\n",
        "Memory free: ", mem_free, " (awk MemFree)"
    ))
}
