
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stagetrackr

<!-- badges: start -->
<!-- badges: end -->

The goal of stagetrackr is to provide a range of tools to optimise
working with data from species which develop through multiple life
stages. It can automatically assign the last observed staged for
individuals in experimental datasheets and plot graphs of: survival
rates through development; distribution of last observed stages with the
ability to specify factors which are separated for the purposes
comparative analysis.

## Installation

You can install the development version of stagetrackr like so:

``` r
install.packages("devtools")
devtools::install_github("EcoHull/stagetrackr")
```

## Usage

The functions in this package are designed to be used in sequence
depending on the questions being answered. But the base data relies on
the recording of the dates that individuals move through developmental
stages.

``` r
library(stagetrackr)

example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")

example_data = dplyr::tribble(
~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5,
  1, "01/01/2000", NA, NA, NA, NA,
  2, "01/01/2000", "02/01/2000", NA, NA, NA,
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA,
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA,
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000",
  6, NA, NA, NA, NA, NA,
)

stage_assigning(columns = example_stages, data = example_data)
#> # A tibble: 6 × 7
#>      ID Stage1     Stage2     Stage3     Stage4     Stage5   last_observed_stage
#>   <dbl> <chr>      <chr>      <chr>      <chr>      <chr>    <chr>              
#> 1     1 01/01/2000 <NA>       <NA>       <NA>       <NA>     Stage1             
#> 2     2 01/01/2000 02/01/2000 <NA>       <NA>       <NA>     Stage2             
#> 3     3 01/01/2000 02/01/2000 03/01/2000 <NA>       <NA>     Stage3             
#> 4     4 01/01/2000 02/01/2000 03/01/2000 04/01/2000 <NA>     Stage4             
#> 5     5 01/01/2000 02/01/2000 03/01/2000 04/01/2000 05/01/2… Stage5             
#> 6     6 <NA>       <NA>       <NA>       <NA>       <NA>     no_stage_found
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
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
