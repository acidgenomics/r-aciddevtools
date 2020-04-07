## More robust versions of these are defined in goalie package.



.hasLength <- function(x) {
    length(x) > 0L
}



.isFlag <- function(x) {
    ok <- is.logical(x)
    if (!isTRUE(ok)) return(FALSE)
    ok <- identical(length(x), 1L)
    if (!isTRUE(ok)) return(FALSE)
    TRUE
}



.isInt <- function(x) {
    ok <- is.integer(x)
    if (!isTRUE(ok)) return(FALSE)
    ok <- identical(length(x), 1L)
    if (!isTRUE(ok)) return(FALSE)
    TRUE
}



.isMacOS <- function() {
    identical(Sys.info()[[1L]], "Darwin")
}



.isString <- function(x) {
    ok <- is.character(x)
    if (!isTRUE(ok)) return(FALSE)
    ok <- identical(length(x), 1L)
    if (!isTRUE(ok)) return(FALSE)
    TRUE
}
