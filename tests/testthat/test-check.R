test_that("check suggests installing missing dependencies", {
    path <- file.path(tempdir(), "aciddevtools-check-missing")
    dir.create(path, showWarnings = FALSE)
    writeLines(
        c(
            "Package: aciddevtoolscheckmissing",
            "Version: 0.0.1",
            "Suggests: aciddevtoolsmissingpackage, aciddevtoolsmissingpackage2"
        ),
        con = file.path(path, "DESCRIPTION")
    )
    error <- expect_error(check(path = path))
    expect_match(
        object = conditionMessage(error),
        regexp = paste0(
            "Run `AcidDevTools::install(pkgs = c(",
            "\"aciddevtoolsmissingpackage\", ",
            "\"aciddevtoolsmissingpackage2\"))` to install them."
        ),
        fixed = TRUE
    )
})
