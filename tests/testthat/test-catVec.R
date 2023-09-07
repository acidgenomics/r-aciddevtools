test_that("Unnamed vector", {
    expect_output(
        object = catVec(c("aaa", "bbb")),
        regexp = "\"aaa\","
    )
})

test_that("Named vector", {
    expect_output(
        object = catVec(c("aaa" = "AAA", "bbb" = "BBB")),
        regexp = "\"aaa\" = \"AAA\","
    )
})
