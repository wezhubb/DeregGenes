# Purpose: prepareData function
# Author: Wenzhu Ye
# Date: 12.7.2022
# Version: 1.0.0
# Bugs and Issues: N/A

#' Preparing CEL data for furthe gene differential expression analysis
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
#' @param isAffymetrix A boolean/logical vector represent the platform of the
#'     sample being prepared. This function will work on two platfrom:
#'     Affymetrix and Entrez. If the data is prepared by Affymetrix, then
#'     enter TRUE, otherwise, enter FALSE.
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
#' Wickham H, François R, Henry L, Müller K (2022).
#'     _dplyr: A Grammar of Data Manipulation_.
#'     R package version 1.0.10, <https://CRAN.R-project.org/package=dplyr>.
#'
#' Stefanska B, Huang J, Bhattacharyya B, Suderman M et al. Definition of the
#'     landscape of promoter DNA hypomethylation in liver cancer. Cancer Res
#'     2011 Sep 1;71(17):5891-903. PMID: 21747116
#'
#' Carvalho B (2015). pd.hg.u133.plus.2: Platform Design Info for The
#'     Manufacturer's Name HG-U133_Plus_2. R package version 3.12.0.
#'
#' @examples
#' # Require download of about 90MB file.
#' # This example's runtime will be around 10 minutes
#' \dontrun{
#' # download data from GEO
#' filePaths <- getGEOSuppFiles("GSE29721")
#'
#' # untar downloaded data and delete tar file
#' untarPath <- strsplit(row.names(filePaths), '/')
#' untarPath <- paste(untarPath[[1]][1:length(untarPath[[1]]) - 1],
#'     collapse="/")
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
#' # import tidyverse
#' # pd.hg.u133.plus.2
#'
#' @export
#' @importFrom oligo read.celfiles rma
#' @importFrom biomaRt useEnsembl getBM
#' @import dplyr
#'

prepareData <- function(celpath, isAffymetrix = TRUE) {
  # --- load in data -----------------
  list <- list.files(celpath, full.names=TRUE)
  data <- oligo::read.celfiles(list)

  # --- normalize data -----------------
  data.rma <- oligo::rma(data)
  data.matrix <- exprs(data.rma)

  # --- annotate probeID to gene symbol -----------------
  rowName <- row.names(data.matrix)

  ensembl <- biomaRt::useEnsembl(biomart = "genes",
                                 dataset = "hsapiens_gene_ensembl")

  # check platform
  if (isAffymetrix) {
    attribute <- 'affy_hg_u133_plus_2'
  } else {
    attribute <- 'entrezgene_id'
  }

  # getting gene symbols
  gN <- biomaRt::getBM(attributes = c(attribute, 'hgnc_symbol'),
              filters = attribute,
              values = rowName,
              mart = ensembl)

  gN <- subset(gN, hgnc_symbol!= '')

  # delete data that the gene ID/peobe ID that have no corresponding gene symbol
  if (isAffymetrix) {
    probelist <- as.list(gN$affy_hg_u133_plus_2)
  } else {
    probelist <- as.list(gN$entrezgene_id)
  }

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
      gene <- dplyr::filter(gN, affy_hg_u133_plus_2 == item)
    } else {
      gene <- dplyr::filter(gN, entrezgene_id == item)
    }

    if (nrow(gene) > 0) {
      rownames(data.matrix)[rownames(data.matrix) == item] <- gene$hgnc_symbol
    }
  }

  return(data.matrix)

}

# [ END]
