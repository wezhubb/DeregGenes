library(DeregGenes)

GSE29721 <- c(4.098850, 3.833557, 3.890763, 3.684879,
              -4.417978, -3.830797, -4.552853,
              -3.380655, -3.374820, -3.264027)
GSE84402 <- c(3.589012, 3.925539, 3.521678, 3.604054,
              -3.320347, -2.763999, -2.634061,
              -2.912856, -2.611786, -2.820383)
mock_data <- data.frame(GSE29721, GSE84402 )
rownames(mock_data) <- c("LINC00844", "MT1M", "GBA3", "APOF", "GPC3", "PEG10",
                         "SPINK1", "TOP2A", "CDKN3", "CTHRC1")


test_that("invalid input", {
  expect_equal(plotHeatMap(mock_data, -1, 3), -1)
  expect_equal(plotHeatMap(mock_data, 1, -3), -1)

})
