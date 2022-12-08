# Purpose: test aggreg
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

library(DeregGenes)

# test for various different invalid inputs
test_that("invalid input", {

  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control")
  result <- logFCsingle(GSE29721, class)

  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control", "mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control")
  result2 <- logFCsingle(GSE84402, class)

  expect_error(Aggreg(list(result), c("GSE29721")))
  expect_error(Aggreg(list(result), c("GSE29721", "GSE84402")))


  listLogFC <- list(result, result2)
  listTitle <- c("GSE29721", "GSE84402")
  expect_error((Aggreg(listLogFC, listTitle, padj = 'a', logFC = 1)))
  expect_error((Aggreg(listLogFC, listTitle, padj = -1, logFC = 1)))
  expect_error((Aggreg(listLogFC, listTitle, padj = 0.01, logFC = -1)))
})

# test for expected output
test_that("expected output", {
  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control")
  result1 <- logFCsingle(GSE29721, class)

  class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control", "mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control")
  result2 <- logFCsingle(GSE84402, class)

  listLogFC <- list(result1, result2)
  listTitle <- c("GSE29721", "GSE84402")
  aggreg <- Aggreg(listLogFC, listTitle, padj = 0.01, logFC = 1)

  expect_type(aggreg, "list")
  expect_equal(length(aggreg), 3)
  expect_type(aggreg[1], "list")
  expect_type(aggreg[2], "list")
  expect_type(aggreg[3], "list")
  expect_equal(length(aggreg[[1]]), 4)
  expect_equal(length(aggreg[[2]]), 4)
  expect_equal(length(aggreg[[3]]), 2)
})

# [END]
