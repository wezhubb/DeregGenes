% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logFCsingle.R
\name{logFCsingle}
\alias{logFCsingle}
\title{Computing gene differential expression across one study}
\usage{
logFCsingle(expressionLevel, setUp)
}
\arguments{
\item{expressionLevel}{A data matrix of gene expression level data, where
each row represent different gene and each column represent different
gene's expression level in different sample}

\item{setUp}{A vector in which the length equals to the number of column
in expressionLevel. This vector will be consist of only two strings
"mutant" and "control", the "mutant" represent disease sample and
"control" represent healthy individual sample. The two strings are
organized in the same order of the columns in expressionLevel. For
example, if the first five samples in expressionLevel are disease,
disease, healthy, disease, healthy. Then the setUp inputed will be
c("mutant", "mutant", "control", "mutant", "control")}
}
\value{
return a data frame where each row represent different genes, and
six columns that gives expressional change(logFC), average
expression(AveExpr), t value(t), p value(P.Value), adjusted p
value(adj.P.Val), and log-odd ratio/B-statistic(B).
}
\description{
logFCsingle is a function to analyze the gene expression data to find
gene expression fold change/gene differential expression for each gene in
a single study.
}
\examples{
\dontrun{
# sample type, for more information, run ?GSE29721
class <- c("mutant", "control","mutant", "control","mutant", "control",
    "mutant", "control","mutant", "control","mutant", "control", "mutant",
    "control","mutant", "control","mutant", "control", "mutant", "control")

logFCsingle(GSE29721, class)
}

}
\references{
Ritchie, M.E., Phipson, B., Wu, D., Hu, Y., Law, C.W., Shi, W., and
Smyth, G.K. (2015). limma powers differential expression analyses for
RNA-sequencing and microarray studies. Nucleic Acids Research 43(7), e47.

Hastie T, Tibshirani R, Narasimhan B, Chu G (2022).
\emph{impute: impute: Imputation for microarray data}. R package version
1.70.0.

Stefanska B, Huang J, Bhattacharyya B, Suderman M et al. Definition of the
landscape of promoter DNA hypomethylation in liver cancer. Cancer Res
2011 Sep 1;71(17):5891-903. PMID: 21747116
}
