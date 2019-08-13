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

## Updated 2019-07-26.
memfree <- function() {
    message("Running garbage collection first with base::gc().")
    print(gc(verbose = TRUE, full = TRUE))
    memUsed <- capture.output(print(mem_used()))
    memFree <- .format.object_size(
        as.numeric(
            system("awk '/MemFree/ {print $2}' /proc/meminfo", intern = TRUE)
        ),
        "auto"
    )
    message(sprintf("Memory used: %d, via 'pryr::mem_used'.", memUsed))
    message(sprintf("Memory free: %d, via 'awk MemFree'.", memFree))
}



## @seealso `utils:::format.object_size()`
## Updated 2019-07-26.

## nolint start

.format.object_size <- function(
    x,
    units = "b",
    standard = "auto",
    digits = 1L,
    ...
) {
    known_bases <- c(legacy = 1024, IEC = 1024, SI = 1000)
    known_units <- list(
        SI = c("B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"),
        IEC = c("B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"),
        legacy = c("b", "Kb", "Mb", "Gb", "Tb", "Pb"),
        LEGACY = c("B", "KB", "MB", "GB", "TB", "PB"))
    units <- match.arg(
        units,
        c("auto", unique(unlist(known_units), use.names = FALSE))
    )
    standard <- match.arg(standard, c("auto", names(known_bases)))
    if (standard == "auto") {
        standard <- "legacy"
        if (units != "auto") {
            if (grepl("iB$", units))
                standard <- "IEC"
            else if (grepl("b$", units))
                standard <- "legacy"
            else if (units == "kB")
                stop("For SI units, specify 'standard = \"SI\"'")
        }
    }
    base <- known_bases[[standard]]
    units_map <- known_units[[standard]]
    if (units == "auto") {
        power <- if (x <= 0)
            0L
        else min(as.integer(log(x, base = base)), length(units_map) - 1L)
    }
    else {
        power <- match(toupper(units), toupper(units_map)) - 1L
        if (is.na(power))
            stop(gettextf("Unit \"%s\" is not part of standard \"%s\"",
                          sQuote(units), sQuote(standard)), domain = NA)
    }
    unit <- units_map[power + 1L]
    if (power == 0 && standard == "legacy")
        unit <- "bytes"
    paste(round(x / base ^ power, digits = digits), unit)
}

## nolint end
