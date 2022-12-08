# Purpose: test plotHeatMap
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

library(DeregGenes)

# -- mock data --
GSE29721_logFC <- c(4.098850, 3.833557, 3.890763, 3.684879,
              -4.417978, -3.830797, -4.552853,
              -3.380655, -3.374820, -3.264027)
GSE84402_logFC <- c(3.589012, 3.925539, 3.521678, 3.604054,
              -3.320347, -2.763999, -2.634061,
              -2.912856, -2.611786, -2.820383)
MOCK_DATA <- data.frame(GSE29721_logFC, GSE84402_logFC )
rownames(MOCK_DATA) <- c("LINC00844", "MT1M", "GBA3", "APOF", "GPC3", "PEG10",
                         "SPINK1", "TOP2A", "CDKN3", "CTHRC1")

# test for various different invalid inputs
test_that("invalid input", {
  expect_error(plotHeatMap(MOCK_DATA, -1, 3))
  expect_error(plotHeatMap(MOCK_DATA, 1, -3))
  expect_error(plotHeatMap(MOCK_DATA, 'a', 1))
  expect_error(plotHeatMap(MOCK_DATA, 1, 'b'))
  expect_error(plotHeatMap())

})

# test for correct output
test_that("correct output", {
  expect_type(plotHeatMap(MOCK_DATA), 'double')

  # test for if nUp and nDown exceed boundary
  expect_equal(plotHeatMap(MOCK_DATA, 100, 100), plotHeatMap(MOCK_DATA))
})

# [END]
