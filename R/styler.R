#' Acid Genomics styler formatting theme
#'
#' @name styler
#' @note Updated 2022-03-14.
#'
#' @return `list`.
#'   List containing styler rule definitions.
#'
#' @seealso
#' - `styler::tidyverse_style`.
#' - https://styler.r-lib.org/articles/customizing_styler.html
#' --https://styler.r-lib.org/articles/remove_rules.html
#' - https://github.com/r-lib/lintr/issues/43
NULL



#' @rdname styler
#' @export
acid_style <-  # nolint
    function() {
        stopifnot(requireNamespace("styler", quietly = TRUE))
        styler::tidyverse_style(
            scope = "tokens",
            strict = TRUE,
            indent_by = 4L,
            start_comments_with_one_space = TRUE
        )
    }
