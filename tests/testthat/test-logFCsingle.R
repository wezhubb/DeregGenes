# Purpose: test logFCsingle
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

library(DeregGenes)

# test for various different invalid inputs
test_that("invalid input", {

  expect_error(DeregGenes::logFCsingle(GSE29721, c()))

  x = c()
  expect_error(DeregGenes::logFCsingle(as.data.frame(x), c()))

  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control", "mutant",
             "control","mutant", "control","mutant", "control", "a", "control")
  expect_error(DeregGenes::logFCsingle(GSE29721, class))

})

# test for expected output
test_that("expected output", {
  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control", "mutant",
             "control","mutant", "control","mutant", "control", "mutant", "control")

  result <- DeregGenes::logFCsingle(GSE29721, class)

  expect_type(result, "list")

  # check columns
  expect_equal(ncol(result), 6)
  expect_equal(colnames(result)[1], "logFC")
  expect_equal(colnames(result)[2], "AveExpr")
  expect_equal(colnames(result)[3], "t")
  expect_equal(colnames(result)[4], "P.Value")
  expect_equal(colnames(result)[5], "adj.P.Val")
  expect_equal(colnames(result)[6], "B")
})

# [END]
