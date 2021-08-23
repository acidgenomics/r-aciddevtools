context("parseRd")

test_that("parseRd", {
    db <- tools::Rd_db("base")
    rd <- db[["nrow.Rd"]]
    expect_is(rd, "Rd")
    tags <- RdTags(rd)
    expect_true("examples" %in% tags)
    examples <- parseRd(rd, tag = "examples")
    expect_is(examples, "character")
})
