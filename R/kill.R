#' Kill current R session
#'
#' @export
#' @note Updated 2019-10-22.
#'
#' @seealso
#' - RStudio: Session > Restart R (Ctrl + Shift + F10)
#' - https://github.com/vsbuffalo/dotfiles/blob/master/.Rprofile
#'
#' Useful kill commands in shell:
#' - `kill -WINCH <PID>`.
#' - `pkill rsession`.
#' - `pgrep rsession`.
#'
#' @examples
#' ## > kill()
kill <- function() {
    system2(command = "kill", args = Sys.getpid())
}
