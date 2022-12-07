# Purpose: plotHeatMap function
# Author: Wenzhu Ye
# Date: 11.15.2022
# Version: 1.0.0
# Bugs and Issues: N/A

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
#'     significant logFC values from up-regulated data. If both nUp and ndown
#'     is not given, all of the data will be plot. Notice that n must be
#'     smaller or equal the number of genes that are up-regulated in data.
#' @param ndown A numeric vector indicate the top n numbers of genes with
#'     significant logFC values from down-regulated data. If both nUp and ndown
#'     is not given, all of the data will be plot. Notice that n must be
#'     smaller or equal the number of genes that are down-regulated in data.
#'
#' @return This function will return 1 if the function has been executed
#'     successfully, and return -1 if error occurred
#'
#' @references
#' Kolde R (2019). _pheatmap: Pretty Heatmaps_.
#'     R package version 1.0.12, <https://CRAN.R-project.org/package=pheatmap>.
#'
#' Wickham H, François R, Henry L, Müller K (2022).
#'     _dplyr: A Grammar of Data Manipulation_.
#'     R package version 1.0.10, <https://CRAN.R-project.org/package=dplyr>.
#'
#' Wang H, Huo X, Yang XR, He J et al. STAT3-mediated upregulation of lncRNA
#'     HOXD-AS1 as a ceRNA facilitates liver cancer metastasis by regulating
#'     SOX4. Mol Cancer 2017 Aug 14;16(1):136. PMID: 28810927
#'
#' Stefanska B, Huang J, Bhattacharyya B, Suderman M et al. Definition of the
#'     landscape of promoter DNA hypomethylation in liver cancer. Cancer Res
#'     2011 Sep 1;71(17):5891-903. PMID: 21747116
#'
#' @examples
#' \dontrun{
#' # compute logFC for data1
#' class <- c("mutant", "control","mutant", "control","mutant", "control",
#'     "mutant", "control","mutant", "control","mutant", "control", "mutant",
#'     "control","mutant", "control","mutant", "control", "mutant", "control")
#' result <- logFCsingle(GSE29721, class)
#'
#' # compute logFC for data2
#' class <- c("mutant", "control","mutant", "control","mutant", "control",
#'     "mutant", "control","mutant", "control","mutant", "control", "mutant",
#'     "control","mutant", "control","mutant", "control", "mutant", "control",
#'     "mutant", "control","mutant", "control", "mutant", "control","mutant",
#'     "control")
#' result2 <- logFCsingle(GSE84402, class)
#'
#' # analysis
#' listLogFC <- list(result, result2)
#' listTitle <- c("GSE29721", "GSE84402")
#' aggreg <- Aggreg(listLogFC, listTitle, padj = 0.01, logFC = 1)
#'
#' # drawing heatmap
#' plotHeatMap(data.frame(aggreg[3]))
#'
#' }
#'
#' @export
#' @import pheatmap
#' @importFrom dplyr %>%

plotHeatMap <- function(data, nUp = -1, nDown = -1) {
  # -- check if data exist--
  if (missing(data)) {
    print("please enter data")
    return(-1)
  }

  # -- check nUp and nDown value --

  if (nUp == -1 && nDown == -1) {
    hminput <- data
  } else if (nUp < 0 | nDown < 0) {
    print("please enter a number greater than 0")
    return(-1)
  } else {
    top <- head(data, 2)
    bottom <- tail(data, 2)
    hminput <- rbind(top, bottom)
  }

  # plot heatmap
  pheatmap::pheatmap(hminput,
           display_numbers = TRUE,
           units = 'cm',
           fontsize_row = 10,
           fontsize_col = 12,
           color = colorRampPalette(c("green", "white","red"))(50),
           cluster_cols = FALSE,
           cluster_rows = FALSE, )

  return(1)
}

# [ END]
