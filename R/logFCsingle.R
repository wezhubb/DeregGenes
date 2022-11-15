#'
#'
#' number of column in expressionLevel should equal to length of setUp
#'
#' @import limma
#' @import impute

logFCsingle <- function(expressionLevel, setUp) {
  # --- impute missing expression data ---
  mat = impute.knn(expressionLevel)
  rt = mat$data
  rt = avereps(rt)

  design <- model.matrix(~ 0 + factor(setUp))
  colnames(design) <- c("mutant","control")
  fit <- lmFit(rt, design)
  cont.matrix <- makeContrasts(mutant - control, levels = design)
  fit2 <- contrasts.fit(fit, cont.matrix)
  fit2 <- eBayes(fit2)

  return(topTable(fit2, adjust = 'fdr', number = nrow(expressionLevel)))
}


