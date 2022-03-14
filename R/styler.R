#' Acid Genomics styler formatting theme
#'
#' @name styler
#' @note Updated 2022-03-14.
#'
#' @return `list`.
#' List containing styler rule definitions.
#'
#' @seealso
#' - `styler::tidyverse_style`.
#' - https://styler.r-lib.org/articles/customizing_styler.html
#' - https://styler.r-lib.org/articles/remove_rules.html
#' - https://styler.r-lib.org/reference/styler_addins.html
#' - https://github.com/r-lib/styler/issues/319
#' - https://github.com/r-lib/lintr/issues/43
NULL



#' @rdname styler
#' @export
acid_style <- # nolint
    function() {
        stopifnot(requireNamespace("styler", quietly = TRUE))
        styler::tidyverse_style(
            scope = "tokens",
            strict = TRUE,
            indent_by = 4L,
            start_comments_with_one_space = TRUE,
            reindention = styler::tidyverse_reindention(),
            math_token_spacing = styler::tidyverse_math_token_spacing()
        )
    }
