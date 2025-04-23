#' Acid Genomics styler formatting theme
#'
#' @name styler
#' @note Updated 2023-08-17.
#'
#' @return `list`.
#' List containing styler rule definitions.
#'
#' @seealso
#' - `styler::tidyverse_style`.
#' - https://styler.r-lib.org/reference/tidyverse_style.html
#' - https://styler.r-lib.org/articles/customizing_styler.html
#' - https://styler.r-lib.org/articles/remove_rules.html
#' - https://styler.r-lib.org/reference/styler_addins.html
#' - https://styler.r-lib.org/reference/style_pkg.html
#' - https://github.com/r-lib/styler/issues/319
#' - https://github.com/r-lib/lintr/issues/43
NULL


#' @rdname styler
#' @export
acid_style <- # nolint
    function() {
        stopifnot(.requireNamespaces("styler"))
        styler::tidyverse_style(
            ## Supported scope (from less invasive to more invasive):
            ## "spaces", "identation", "line_breaks", "tokens".
            scope = "tokens",
            strict = TRUE,
            indent_by = 4L,
            start_comments_with_one_space = TRUE,
            reindention = styler::tidyverse_reindention(),
            math_token_spacing = styler::tidyverse_math_token_spacing()
        )
    }
