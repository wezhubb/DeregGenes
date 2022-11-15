#'
#'
#'
#'
#'
#'
#' @import RobustRankAggreg


Aggreg <- function(listLogFC, listTitle, padj = 0, logFC = 0, isUp) {
  up_list = list()
  down_list = list()
  allFCList = list()
  for(i in 1:length(listLogFC)) {
    inputFile = data.frame(listLogFC[i])
    inputFile$gene <- rownames(inputFile)
    inputFile <- inputFile[,c(ncol(inputFile),1:(ncol(inputFile)-1))]
    rt <- inputFile[order(inputFile$logFC),]
    header = listTitle[i]
    down_list[[header[1]]] = as.vector(rt[,1])
    up_list[[header[1]]] = rev(as.vector(rt[,1]))
    fcCol = rt[,1:2]
    colnames(fcCol) = c('GENE', header[[1]])
    allFCList[[header[1]]] = fcCol
  }

  newTab = Reduce(mergeLe, allFCList)
  rownames(newTab) = newTab[,1]
  newTab = newTab[,2:ncol(newTab)]
  newTab[is.na(newTab)] = 0

  if (isUp) {
    upMatrix = RobustRankAggreg::rankMatrix(up_list)
    upAR = aggregateRanks(rmat = upMatrix)
    colnames(upAR) = c("Name", "Pvalue")
    upAdj = p.adjust(upAR$Pvalue, method = "bonferroni")
    upXls = cbind(upAR, adjPvalue = upAdj)
    upFC = newTab[as.vector(upXls[,1]),]
    upXls = cbind(upXls, logFC = rowMeans(upFC))
    upSig = upXls[(upXls$adjPvalue<padj & upXls$logFC>logFC),]

    return(upSig)

  } else {
    downMatrix = RobustRankAggreg::rankMatrix(down_list)
    downAR = aggregateRanks(rmat = downMatrix)
    colnames(downAR) = c("Name", "Pvalue")
    downAdj = p.adjust(downAR$Pvalue, method = "bonferroni")
    downXls = cbind(downAR, adjPvalue = downAdj)
    downFC = newTab[as.vector(downXls[,1]),]
    downXls = cbind(downXls, logFC = rowMeans(downFC))
    downSig = downXls[(downXls$adjPvalue<padj & downXls$logFC< -logFC),]

    return(downSig)

  }




}

mergeLe = function(x,y) {
  merge(x,y,by = "Gene", all = T)
}
