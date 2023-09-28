test_that("parseRd", {
    db <- tools::Rd_db("base")
    rd <- db[["nrow.Rd"]]
    expect_s3_class(rd, "Rd")
    tags <- rdTags(rd)
    expect_true("examples" %in% tags)
    examples <- parseRd(rd, tag = "examples")
    expect_type(examples, "character")
})
