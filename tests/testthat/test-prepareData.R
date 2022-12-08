library(DeregGenes)

# test for various different invalid inputs
test_that("invalid input", {
  # test for empty path
  expect_error(prepareData(""))

  # test for file not in CEL format
  expect_error(prepareData("../../data/GSE29721.rda"))
  expect_error(prepareData("../../inst/extdata/GSE29721.csv"))

})
# [END]
