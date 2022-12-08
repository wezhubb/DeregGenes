# Purpose: test prepareDara
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

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
