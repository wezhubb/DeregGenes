# Purpose: Aggreg function
# Author: Wenzhu Ye
# Date: 11.15.2022
# Version: 1.0.0
# Bugs and Issues: N/A

#' aggregate gene differential expression from different studies together
#'
#' Aggreg is a function to aggregate different gene expression fold changes
#' across different studies. This function will only keep the genes that
#' all the studies have data of.
#'
#' @param listLogFC A vector of all the studies gene differential expression
#'     data. For each study's data, the format should be in data frame, and
#'     each row represent different genes(with the gene symbol as its row
#'     name). The first should be the expressional change(logFC). The length of
#'     this list should be at least 2 for the purpose of this function
#' @param listTitle A vector of strings. The length of listTile should be the
#'     same of the length of the listLogFC. listTile should consist of the
#'     title/name of the studies as in the same orders of the studies in
#'     listLogFC
#' @param padj A numeric vector that represent the adjust p value threshold,
#'     if nothing is entered, the default value of 0.01 will be used.
#' @param logFC A numeric vector that represent the logFC threshold, if
#'     nothing is entered, the default value of 1 will be used.
#'
#' @return Return a list of length three. The first element of the list is
#'     a data frame of up-regulated differential genes. The second element of
#'     the list is a data frame of down-regulated differential genes. For the
#'     first two data frame, each row a a different genes, and there will be
#'     four columns: gene symbol(Name), p value(Pvalue), adjust p
#'     value(adjPvalue), and expressional change(logFC). The last element of
#'     the list is a aggregated data frame where each row is a gene,
#'     and each column is the logFC of different studies. If error occurs,
#'     -1 will be returned.
#'
#' @references
#' Kolde R (2022). _RobustRankAggreg: Methods for Robust Rank Aggregation_.
#'     R package version 1.2.1,
#'     <https://CRAN.R-project.org/package=RobustRankAggreg>.
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
#' }
#'
#' @export
#' @import RobustRankAggreg


Aggreg <- function(listLogFC, listTitle, padj = 0.01, logFC = 1) {
  if (length(listLogFC) < 2) {
    print("please enter more than one study")
    return(-1)
  }

  # --- init different list -----------------
  upList <- list()
  downList <- list()
  allFCList <- list()

  # --- put all data in listLogFC into allFCList -----------------
  for (i in 1:length(listLogFC)) {
    # prepare input
    inputFile <- data.frame(listLogFC[i])
    inputFile$gene <- rownames(inputFile)
    inputFile <- inputFile[, c(ncol(inputFile), 1:(ncol(inputFile)-1))]
    rt <- inputFile[order(inputFile$logFC), ]
    header <- listTitle[i]

    # prepare downList and upList
    downList[[header[[1]][1]]] <- as.vector(rt[, 1])
    upList[[header[[1]][1]]] <- rev(as.vector(rt[, 1]))

    fcCol <- rt[, 1:2]
    colnames(fcCol) <- c('GENE', header[[1]])
    allFCList[[header[[1]][1]]] <- fcCol
  }

  # --- merge list -----------------
  newTab <- Reduce(function(x, y) merge(x, y, by = "GENE", all = T), allFCList)
  rownames(newTab) <- newTab[, 1]
  newTab <- newTab[, 2:ncol(newTab)]
  # remove NA
  newTab[is.na(newTab)] <- 0

  # --- give significant up-regulated genes -----------------
  # prepare
  upMatrix <- RobustRankAggreg::rankMatrix(upList)
  upAR <- aggregateRanks(rmat = upMatrix)
  colnames(upAR) <- c("Name", "Pvalue")

  # adjust p value
  upAdj <- p.adjust(upAR$Pvalue, method = "bonferroni")

  # bind tables
  upXls <- cbind(upAR, adjPvalue = upAdj)
  upFC <- newTab[as.vector(upXls[, 1]), ]

  # all genes
  upXls <- cbind(upXls, logFC = rowMeans(upFC))

  # select out significant up-regulated genes
  upSig <- upXls[((upXls$adjPvalue < padj) & (upXls$logFC > logFC)) ,]

  # --- give significant down-regulated genes -----------------
  # prepare
  downMatrix <- RobustRankAggreg::rankMatrix(downList)
  downAR <- aggregateRanks(rmat = downMatrix)
  colnames(downAR) <- c("Name", "Pvalue")

  # adjust p value
  downAdj <- p.adjust(downAR$Pvalue, method = "bonferroni")

  # bind tables
  downXls <- cbind(downAR, adjPvalue = downAdj)
  downFC <- newTab[as.vector(downXls[,1]), ]

  # all genes
  downXls <- cbind(downXls, logFC = rowMeans(downFC))

  # select out significant down-regulated genes
  downSig <- downXls[((downXls$adjPvalue < padj) & (downXls$logFC < -logFC)), ]

  hminput <- newTab[c(as.vector(upSig[1:nrow(upSig), 1]),
                      as.vector(downSig[1:nrow(downSig), 1])), ]

  print('a success')

  return(list(upSig, downSig, hminput))

}

# [ END]
