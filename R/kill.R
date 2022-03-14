## nocov start



#' Kill R session
#'
#' @name kill
#' @note Updated 2019-10-23.
#'
#' @param pid `integer(1)`.
#' Process ID.
#'
#' @seealso
#' - RStudio: Session > Restart R (Ctrl + Shift + F10)
#' - https://github.com/vsbuffalo/dotfiles/blob/master/.Rprofile
#'
#' Useful kill commands in shell:
#' - `pgrep rsession`.
#' - `pkill rsession`.
#' - `kill -WINCH <PID>`.
#'
#' @examples
#' ## > kill()
#' ## > killAll()
NULL



#' @rdname kill
#' @export
kill <- function(pid = Sys.getpid()) {
    system2(command = "kill", args = pid)
}



#' @rdname kill
#' @export
killAll <- function() {
    system2(command = "pkill", args = "rsession")
}



## nocov end
