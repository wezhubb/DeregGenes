#' drawing heatmap of gene differential expression data
#'
#' plotHeatMap is a function used to draw a heatmap representation of
#' differential gene expression.
#'
#' This function has no return value, the after the function being executed,
#' a heatmap file named "logFC.tiff" will be saved into current directory.
#'
#' @param data A dataframe where each row is a gene(row name is the gene
#'     symbol),and each column is the logFC of different
#'     studies(column name is the study name). The data frame must be in
#'     order, where the gene with highest logFC value acorss all studies
#'     should be at the top, and the gene with lowest logFC value acorss all
#'     studies should be at the bottom
#' @param nUp A numeric vector indicate the top n numbers of genes with
#'     significant logFC values from up-regulated data. This number must bigger
#'     than 1. Notice that n must be smaller or equal the number of genes that
#'     are up-regulated in data.
#' @param ndown A numeric vector indicate the top n numbers of genes with
#'     significant logFC values from down-regulated data. This number must bigger
#'     than 1. Notice that n must be smaller or equal the number of genes that
#'     are down-regulated in data.
#'
#' @references
#' Kolde R (2019). _pheatmap: Pretty Heatmaps_.
#'     R package version 1.0.12, <https://CRAN.R-project.org/package=pheatmap>.
#'
#' Wickham H, François R, Henry L, Müller K (2022).
#'     _dplyr: A Grammar of Data Manipulation_.
#'     R package version 1.0.10, <https://CRAN.R-project.org/package=dplyr>.
#'
#' @examples
#' # Require download of about 300MB file.
#' \dontrun{
#' # download data1 from GEO
#' filePaths <- getGEOSuppFiles("GSE29721")
#'
#' # untar downloaded data1 and delete tar file
#' untarPath <- strsplit(row.names(filePaths), '/')
#' untarPath <- paste(untarPath[[1]][1:length(untarPath[[1]]) - 1],
#'     collapse="/")
#' untar(row.names(filePaths), exdir = untarPath)
#' unlink(paste(untarPath, '/*.tar', sep = ''))
#'
#' # preparing data1
#' data1 <- prepareData(untarPath, TRUE)
#'
#' # compute logFC for data1
#' class <- c("mutant", "control","mutant", "control","mutant", "control",
#'     "mutant", "control","mutant", "control","mutant", "control", "mutant",
#'     "control","mutant", "control","mutant", "control", "mutant", "control")
#' result <- logFCsingle(data1, class)
#'
#' # delete all download data1
#' unlink(untarPath, recursive = TRUE)
#'
#' # download data2 from GEO
#' filePaths <- getGEOSuppFiles("GSE84402")
#'
#' # untar downloaded data2 and delete tar file
#' untarPath <- strsplit(row.names(filePaths), '/')
#' untarPath <- paste(untarPath[[1]][1:length(untarPath[[1]]) - 1],
#'     collapse="/")
#' untar(row.names(filePaths), exdir = untarPath)
#' unlink(paste(untarPath, '/*.tar', sep = ''))
#'
#' # preparing data2
#' data2 <- prepareData(untarPath, TRUE)
#'
#' # compute logFC for data2
#' class <- c("mutant", "control","mutant", "control","mutant", "control",
#'     "mutant", "control","mutant", "control","mutant", "control", "mutant",
#'     "control","mutant", "control","mutant", "control", "mutant", "control",
#'     "mutant", "control","mutant", "control", "mutant", "control","mutant",
#'     "control")
#' result2 <- logFCsingle(data2, class)
#'
#' # delete all download data2
#' unlink(untarPath, recursive = TRUE)
#'
#'
#' # aggregate
#' listLogFC <- c(result, result2)
#' listTitle <- c("GSE29721", "GSE84402")
#' aggreg <- Aggreg(listLogFC, listTitle)
#'
#' # drawing heatmap
#' plotHeatMap(data.frame(aggreg[3]), 4, 6)
#'
#' }
#'
#' @export
#' @import pheatmap
#' @import dplyr

## TODO: finish up error message in part 2
## TODO: fix tiff bug in part 2
plotHeatMap <- function(data, nUp, nDown) {

  if (missing(data) && missing(down)) {
    print("please enter data")
    return()
  }

  hminput <- data
  # hminput <- data %>% filter(row_number() <= nUp | row_number() > nrow(data) - nDown)

  w <- ncol(hminput)
  h <- nrow(hminput)

  # setting up graph environment
  tiff(file = "logFC.tiff",
       width = 15,
       height = 20,
       units = "cm",
       compression = "lzw",
       bg = "white",
       res = 400)

  pheatmap(hminput,
           display_numbers = TRUE,
           fontsize_row = 10,
           fontsize_col = 12,
           color = colorRampPalette(c("green", "white","red"))(50),
           cluster_cols = FALSE,
           cluster_rows = FALSE, )

  par()
  dev.off()

  return()
}
