
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DeregGenes

<!-- badges: start -->
<!-- badges: end -->

## Description

The main objective of DeregGenes is to find genes that are
deregulated(up-regulate and down- regulate) in different diseases. This
package could also allow users to put different results together to
generate a heatmap for cross studies analysis. It improves users’ time
on massive data cleaning and data annotating processes prior to the
analysis since different data prepared by different platforms will need
to be handled by different tools. Moreover, this package provides a
simple way to let users get a summarised result across multiple current
studies data to provide them with a more confident result and
conclusion. Also, using this package will save users time to switch back
and forth between different distinct packages and learn different
documentation since the different packages will require different input
data types which is not available on any current published r package.

R requirement: 4.2.0 or later version Development platform: Mac

## Installation

You can install the development version of DeregGenes from
[GitHub](https://github.com/) with:

``` r
require("devtools")
#> Loading required package: devtools
#> Loading required package: usethis
devtools::install_github("wezhubb/DeregGenes", build_vignettes = TRUE)
#> Downloading GitHub repo wezhubb/DeregGenes@HEAD
#> Skipping 5 packages not available: limma, oligo, impute, biomaRt, affy
#> * checking for file ‘/private/var/folders/8j/xj1c7l6s505b2r61h7_hktsw0000gn/T/RtmpOD1zZ9/remotesab9ab5e9de6/wezhubb-DeregGenes-b561edb/DESCRIPTION’ ... OK
#> * preparing ‘DeregGenes’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Omitted ‘LazyData’ from DESCRIPTION
#> * building ‘DeregGenes_0.1.0.tar.gz’
library("DeregGenes")
#> Warning: replacing previous import 'biomaRt::select' by 'dplyr::select' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'affy::mm<-' by 'oligo::mm<-' when loading
#> 'DeregGenes'
#> Warning: replacing previous import 'limma::backgroundCorrect' by
#> 'oligo::backgroundCorrect' when loading 'DeregGenes'
#> Warning: replacing previous import 'affy::mmindex' by 'oligo::mmindex' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'affy::pm' by 'oligo::pm' when loading
#> 'DeregGenes'
#> Warning: replacing previous import 'affy::probeNames' by 'oligo::probeNames'
#> when loading 'DeregGenes'
#> Warning: replacing previous import 'affy::rma' by 'oligo::rma' when loading
#> 'DeregGenes'
#> Warning: replacing previous import 'affy::intensity' by 'oligo::intensity' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'affy::MAplot' by 'oligo::MAplot' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'dplyr::summarize' by 'oligo::summarize' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'affy::pmindex' by 'oligo::pmindex' when
#> loading 'DeregGenes'
#> Warning: replacing previous import 'affy::pm<-' by 'oligo::pm<-' when loading
#> 'DeregGenes'
#> Warning: replacing previous import 'affy::mm' by 'oligo::mm' when loading
#> 'DeregGenes'
```

## Overview

``` r
ls("package:DeregGenes")
#> [1] "Aggreg"      "logFCsingle" "plotHeatMap" "prepareData"
browseVignettes("DeregGenes")
#> No vignettes found by browseVignettes("DeregGenes")
```

<img src="./inst/extdata/flowchart.jpeg" style="width:75.0%" />

## Contributions

## Acknowledgements

This package was developed as part of an assessment for 2022f BCB410H:
Applied Bioinformatics, University of Toronto, Toronto, Canada.

## References

Carvalho B. S., and Irizarry, R. A. 2010. A Framework for
Oligonucleotide Microarray Preprocessing Bioinformatics.

Gautier, L., Cope, L., Bolstad, B. M., and Irizarry, R. A. 2004.
affy—analysis of Affymetrix GeneChip data at the probe level.
Bioinformatics 20, 3 (Feb. 2004), 307-315.

Mapping identifiers for the integration of genomic datasets with the
R/Bioconductor package biomaRt. Steffen Durinck, Paul T. Spellman, Ewan
Birney and Wolfgang Huber, Nature Protocols 4, 1184-1191 (2009).

BioMart and Bioconductor: a powerful link between biological databases
and microarray data analysis. Steffen Durinck, Yves Moreau, Arek
Kasprzyk, Sean Davis, Bart De Moor, Alvis Brazma and Wolfgang Huber,
Bioinformatics 21, 3439-3440 (2005).

Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E,
Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K,
Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.”
*Journal of Open Source Software*, *4*(43), 1686.
<doi:10.21105/joss.01686> <https://doi.org/10.21105/joss.01686>.

Wickham H, François R, Henry L, Müller K (2022). *dplyr: A Grammar of
Data Manipulation*. R package version 1.0.10,
<https://CRAN.R-project.org/package=dplyr>.

Ritchie, M.E., Phipson, B., Wu, D., Hu, Y., Law, C.W., Shi, W., and
Smyth, G.K. (2015). limma powers differential expression analyses for
RNA-sequencing and microarray studies. Nucleic Acids Research 43(7),
e47.

Hastie T, Tibshirani R, Narasimhan B, Chu G (2022). *impute: impute:
Imputation for microarray data*. R package version 1.70.0.

Kolde R (2022). *RobustRankAggreg: Methods for Robust Rank Aggregation*.
R package version 1.2.1,
<https://CRAN.R-project.org/package=RobustRankAggreg>.

Kolde R (2019). *pheatmap: Pretty Heatmaps*. R package version 1.0.12,
<https://CRAN.R-project.org/package=pheatmap>.
