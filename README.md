
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DeregGenes

<!-- badges: start -->
<!-- badges: end -->

The goal of DeregGenes is to …

## Installation

You can install the development version of DeregGenes from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("wezhubb/DeregGenes")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## library(DeregGenes)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

## References

Gautier, L., Cope, L., Bolstad, B. M., and Irizarry, R. A. 2004.
affy—analysis of Affymetrix GeneChip data at the probe level.
Bioinformatics 20, 3 (Feb. 2004), 307-315.

Ritchie, M.E., Phipson, B., Wu, D., Hu, Y., Law, C.W., Shi, W., and
Smyth, G.K. (2015). limma powers differential expression analyses for
RNA-sequencing and microarray studies. Nucleic Acids Research 43(7),
e47.

Hastie T, Tibshirani R, Narasimhan B, Chu G (2022). *impute: impute:
Imputation for microarray data*. R package version 1.70.0.

Kolde R (2019). *pheatmap: Pretty Heatmaps*. R package version 1.0.12,
<https://CRAN.R-project.org/package=pheatmap>.

Kolde R (2022). *RobustRankAggreg: Methods for Robust Rank Aggregation*.
R package version 1.2.1,
<https://CRAN.R-project.org/package=RobustRankAggreg>.
