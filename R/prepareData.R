#' preparing CEL data for furthe gene differential expression analysis
#'
#' prepareData is a function used to clean and annotate the data,
#' including handling raw CEL format data, putting together different
#' individual samples into a table, converting different gene IDs and probe IDs
#' to universal HGNC gene symbols, and joining different tables. This function
#' will create a data matrix in which each row represent different gene(with the
#' gene symbol in its rowname), and each column represent different gene's
#' expression level in different sample.
#'
#' This function will remove data with duplicate gene symbol, and remove
#' all data that with gene ID/probe ID that could not be converted to gene
#' symbol
#'
#' @param celpath A string of the file path to local directory in which that
#'     directory only contain CEL gene expression level format data. Notice in
#'     order to fulfill the purpose of this analysis, all the sample data from
#'     the celpath directory will be from the same study.
#'
#' @param isAffymetrix A boolean represent the platform of the sample being
#'     prepared. This function will work on two platfrom: Affymetrix and Entrez. If
#'     the data is prepared by Affymetrix, then enter TRUE, otherwise, enter FALSE.
#'
#' @return return a data matrix of cleaned and organized data.
#'
#' @references
#' Carvalho B. S., and Irizarry, R. A. 2010. A Framework for Oligonucleotide
#'     Microarray Preprocessing Bioinformatics.

#' Gautier, L., Cope, L., Bolstad, B. M., and Irizarry, R. A. 2004.
#'     affy---analysis of Affymetrix GeneChip data at the probe level.
#'     Bioinformatics 20, 3 (Feb. 2004), 307-315.
#'
#' Mapping identifiers for the integration of genomic datasets with the
#'     R/Bioconductor package biomaRt. Steffen Durinck, Paul T. Spellman,
#'     Ewan Birney and Wolfgang Huber, Nature Protocols 4, 1184-1191 (2009).
#'
#' BioMart and Bioconductor: a powerful link between biological databases and
#'     microarray data analysis. Steffen Durinck, Yves Moreau, Arek Kasprzyk,
#'     Sean Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber,
#'     Bioinformatics 21, 3439-3440 (2005).
#'
#' Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G,
#'     Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM,
#'     Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K,
#'     Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.”
#'     _Journal of Open Source Software_, *4*(43), 1686.
#'     doi:10.21105/joss.01686 <https://doi.org/10.21105/joss.01686>.
#'
#' @example
#' # Require download of about 90MB file.
#' \dontrun{
#' # download data from GEO
#' filePaths <- getGEOSuppFiles("GSE29721")
#'
#' # untar downloaded data and delete tar file
#' untarPath <- strsplit(row.names(filePaths), '/')
#' untarPath <- paste(untarPath[[1]][1:length(untarPath[[1]]) - 1], collapse="/")
#' untar(row.names(filePaths), exdir = untarPath)
#' unlink(paste(untarPath, '/*.tar', sep = ''))
#'
#' # running analysis
#' prepareData(untarPath, TRUE)
#'
#' # delete all download data
#' unlink(untarPath, recursive = TRUE)
#' }
#'
#' @export
#' @import affy
#' @import oligo
#' @import biomaRt
#' @import tidyverse
#'

prepareData <- function(celpath, isAffymetrix = TRUE) {
  # --- load in data ---
  list <- list.files(celpath,full.names=TRUE)
  data <- read.celfiles(list)

  # -- normalize data --
  data.rma <- rma(data)
  data.matrix <- exprs(data.rma)

  # --- annotate probeID to gene symbol ---
  rowName <- row.names(data.matrix)

  ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")

  # check platform
  if (isAffymetrix) {
    attribute <- 'affy_hg_u133_plus_2'
  } else {
    attribute <- 'entrezgene_id'
  }

  # getting gene symbols
  gN <- getBM(attributes = c(attribute, 'hgnc_symbol'),
              filters = attribute,
              values = rowName,
              mart = ensembl)

  gN <- subset(gN, hgnc_symbol!='')

  # delete data that the gene ID/peobe ID that have no corresponding gene symbol
  probelist <- as.list(gN$affy_hg_u133_plus_2)
  rowToDelete <- c()

  for (item in rowName) {
    if (!item %in% probelist) {
      rowToDelete <- append(rowToDelete, item)
    }
  }

  data.matrix <- data.matrix[!(row.names(data.matrix) %in% rowToDelete),]
  rowName <- row.names(data.matrix)

  # change row names to gene symbols
  for (item in rowName) {
    if (isAffymetrix) {
      gene <- gN %>% filter(affy_hg_u133_plus_2 == item)
    } else {
      gene <- gN %>% filter(entrezgene_id == item)
    }

    if (nrow(gene) > 0) {
      rownames(data.matrix)[rownames(data.matrix) == item] <- gene$hgnc_symbol
    }
  }

  return(data.matrix)

}