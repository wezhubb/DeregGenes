# Purpose: logFCsingle function
# Author: Wenzhu Ye
# Date: 11.15.2022
# Version: 1.0.0
# Bugs and Issues: N/A

#' computing gene differential expression across one study
#'
#' logFCsingle is a function to analyze the gene expression data to find
#' gene expression fold change/gene differential expression for each gene in
#' a single study.
#'
#' @param expressionLevel A data matrix of gene expression level data, where
#'     each row represent different gene and each column represent different
#'     gene's expression level in different sample
#' @param setUp A vector in which the length equals to the number of column
#'     in expressionLevel. This vector will be consist of only two strings
#'     "mutant" and "control", the "mutant" represent disease sample and
#'     "control" represent healthy individual sample. The two strings are
#'     organized in the same order of the columns in expressionLevel. For
#'     example, if the first five samples in expressionLevel are disease,
#'     disease, healthy, disease, healthy. Then the setUp inputed will be
#'     c("mutant", "mutant", "control", "mutant", "control")
#'
#' @return return a data frame where each row represent different genes, and
#'     six columns that gives expressional change(logFC), average
#'     expression(AveExpr), t value(t), p value(P.Value), adjusted p
#'     value(adj.P.Val), and log-odd ratio/B-statistic(B).
#'
#' @references
#' Ritchie, M.E., Phipson, B., Wu, D., Hu, Y., Law, C.W., Shi, W., and
#'     Smyth, G.K. (2015). limma powers differential expression analyses for
#'     RNA-sequencing and microarray studies. Nucleic Acids Research 43(7), e47.
#'
#' Hastie T, Tibshirani R, Narasimhan B, Chu G (2022).
#'     _impute: impute: Imputation for microarray data_. R package version
#'     1.70.0.
#'
#' Stefanska B, Huang J, Bhattacharyya B, Suderman M et al. Definition of the
#'     landscape of promoter DNA hypomethylation in liver cancer. Cancer Res
#'     2011 Sep 1;71(17):5891-903. PMID: 21747116
#'
#' @examples
#' \dontrun{
#' # sample type, for more information, run ?GSE29721
#' class <- c("mutant", "control","mutant", "control","mutant", "control",
#'     "mutant", "control","mutant", "control","mutant", "control", "mutant",
#'     "control","mutant", "control","mutant", "control", "mutant", "control")
#'
#' logFCsingle(GSE29721, class)
#' }
#'
#' @export
#' @import limma
#' @import impute

logFCsingle <- function(expressionLevel, setUp) {
  # --- impute missing expression data -----------------
  mat <- impute.knn(expressionLevel)
  rt <- mat$data
  rt <- avereps(rt)

  # --- drawing fit linear model -----------------
  design <- model.matrix(~ 0 + factor(setUp))
  colnames(design) <- c("mutant","control")
  fit <- lmFit(rt, design)
  cont.matrix <- makeContrasts(mutant - control, levels = design)
  fit2 <- contrasts.fit(fit, cont.matrix)
  fit2 <- eBayes(fit2)

  print('success')

  return(topTable(fit2, adjust = 'fdr', number = nrow(expressionLevel)))
}

# [ END]

