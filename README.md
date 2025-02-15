
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

The first stage of stagetrackr analysis is to use the
`assigned_stages()` function. This function takes the data frame and the
stage order and returns the last observed developmental stage seen in
each row, creating a column which is a factor with levels dictated by
the provided columns.

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

assigned_stages = stage_assigning(columns = example_stages, data = example_data)
show(assigned_stages)
#> # A tibble: 6 × 7
#>      ID Stage1     Stage2     Stage3     Stage4     Stage5   last_observed_stage
#>   <dbl> <chr>      <chr>      <chr>      <chr>      <chr>    <fct>              
#> 1     1 01/01/2000 <NA>       <NA>       <NA>       <NA>     Stage1             
#> 2     2 01/01/2000 02/01/2000 <NA>       <NA>       <NA>     Stage2             
#> 3     3 01/01/2000 02/01/2000 03/01/2000 <NA>       <NA>     Stage3             
#> 4     4 01/01/2000 02/01/2000 03/01/2000 04/01/2000 <NA>     Stage4             
#> 5     5 01/01/2000 02/01/2000 03/01/2000 04/01/2000 05/01/2… Stage5             
#> 6     6 <NA>       <NA>       <NA>       <NA>       <NA>     <NA>
```

Following the use of `stage_assigning()` a data table can be created
using `last_stage_table()` this functions requires the specifying of the
data frame, the column containing the last observed stages and a list of
the stages in order and returns information about the stage
distribution.

This function is designed to work with the output of `assigned_stages()`
but will alwo work with any dataset with one row per individual and a
column specifying final recorded developmental stage.

``` r

data_table = last_stage_table(data = assigned_stages, last_observed_stage = "last_observed_stage")
show(data_table)
#> # A tibble: 5 × 6
#>   last_observed_stage     n percentage cumulative remaining_n
#>   <fct>               <int>      <dbl>      <int>       <int>
#> 1 Stage1                  1         20          1           5
#> 2 Stage2                  1         20          2           4
#> 3 Stage3                  1         20          3           3
#> 4 Stage4                  1         20          4           2
#> 5 Stage5                  1         20          5           1
#> # ℹ 1 more variable: remaining_percentage <dbl>
```

The `visualisig_survival()` function is designed to work with the output
of `last_stage_table()`. It requires the specification of the data
frame, remaining percentage column and optionally the remaining number
column (if it is not provided it will not show the N value). This
functions generates a bar chart with a bar for each developmental stage
providing details of the remaining percentage (and optionally the N
remaining) at each stage of development.

``` r

visualising_survival(data = data_table, stages = last_observed_stage, remaining_percentage = remaining_percentage, remaining_number = remaining_n)
```

<img src="man/figures/README-visualising_survival_example-1.png" width="100%" />

The distribution of the last observed stages can also be visualised.
This used the `visualising_distribution()` function which is designed to
work with the output of the `stage_assigning()` function. This requires
the specification of the data frame, the column containing the assigned
stages, and optionally a factor column. If a factor column is specified,
a new bar will be generated for each factor.

``` r

# No factor visualisation

visualising_distribution(data = assigned_stages, stage = last_observed_stage)
```

<img src="man/figures/README-visualising_distrubution_no_factor_example-1.png" width="100%" />

``` r

# With factors specified
data_with_factor = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage, ~Sex,
  1, "01/01/2000", NA, NA, NA, NA, "Stage1", "Male",
  2, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "Male",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "Male",
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4", "Male",
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "Male",
  6, NA, NA, NA, NA, NA, "no_stage_found", "Male",
  1, "01/01/2000", NA, NA, NA, NA, "Stage1", "Female",
  2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2", "Female",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "Female",
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "Female",
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "Female",
  6, NA, NA, NA, NA, NA, "no_stage_found", "Female"
)

show(data_with_factor)
#> # A tibble: 12 × 8
#>       ID Stage1     Stage2     Stage3    Stage4 Stage5 last_observed_stage Sex  
#>    <dbl> <chr>      <chr>      <chr>     <chr>  <chr>  <chr>               <chr>
#>  1     1 01/01/2000 <NA>       <NA>      <NA>   <NA>   Stage1              Male 
#>  2     2 01/01/2000 02/01/2000 03/01/20… <NA>   <NA>   Stage3              Male 
#>  3     3 01/01/2000 02/01/2000 03/01/20… <NA>   <NA>   Stage3              Male 
#>  4     4 01/01/2000 02/01/2000 03/01/20… 04/01… <NA>   Stage4              Male 
#>  5     5 01/01/2000 02/01/2000 03/01/20… 04/01… 05/01… Stage5              Male 
#>  6     6 <NA>       <NA>       <NA>      <NA>   <NA>   no_stage_found      Male 
#>  7     1 01/01/2000 <NA>       <NA>      <NA>   <NA>   Stage1              Fema…
#>  8     2 01/01/2000 02/01/2000 <NA>      <NA>   <NA>   Stage2              Fema…
#>  9     3 01/01/2000 02/01/2000 03/01/20… <NA>   <NA>   Stage3              Fema…
#> 10     4 01/01/2000 02/01/2000 03/01/20… 04/01… 05/01… Stage5              Fema…
#> 11     5 01/01/2000 02/01/2000 03/01/20… 04/01… 05/01… Stage5              Fema…
#> 12     6 <NA>       <NA>       <NA>      <NA>   <NA>   no_stage_found      Fema…
```

``` r
visualising_distribution(data = data_with_factor, stage = last_observed_stage, factor = Sex)
```

<img src="man/figures/README-visualising_distribution_example_with_factor-1.png" width="100%" />

### Time span analysis

For development time analysis first the data must be formatted. In order
to do this it must first be handled as a date. This is done using
`time_formatr` which requires a data frame, column and time format
specification, this function uses the as.Date() function, this
determines the specification required.

``` r

example_data = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~Sex,
  1, "01/01/2000", NA, NA, NA, NA, "Male",
  2, "01/01/2000", "03/01/2000", NA, NA, NA, "Male",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Male",
  4, "01/01/2000", "04/01/2000", "05/01/2000", "06/01/2000", NA, "Male",
  5, "01/01/2000", "02/01/2000", "04/01/2000", "07/01/2000", "10/01/2000", "Male",
  6, NA, NA, NA, NA, NA, "Female",
  7, "01/01/2000", NA, NA, NA, NA, "Female",
  8, "01/01/2000", "04/01/2000", NA, NA, NA, "Female",
  9, "01/01/2000", "03/01/2000", "05/01/2000", "09/01/2000", "12/01/2000", "Female",
  10, "01/01/2000", "05/01/2000", "06/01/2000", "07/01/2000", "11/01/2000", "Female"
)

formatted_time = time_formatr(example_data, example_stages, "%d/%m/%Y")
show(formatted_time)
#> # A tibble: 10 × 7
#>       ID Stage1     Stage2     Stage3     Stage4     Stage5     Sex   
#>    <dbl> <date>     <date>     <date>     <date>     <date>     <chr> 
#>  1     1 2000-01-01 NA         NA         NA         NA         Male  
#>  2     2 2000-01-01 2000-01-03 NA         NA         NA         Male  
#>  3     3 2000-01-01 2000-01-02 2000-01-03 NA         NA         Male  
#>  4     4 2000-01-01 2000-01-04 2000-01-05 2000-01-06 NA         Male  
#>  5     5 2000-01-01 2000-01-02 2000-01-04 2000-01-07 2000-01-10 Male  
#>  6     6 NA         NA         NA         NA         NA         Female
#>  7     7 2000-01-01 NA         NA         NA         NA         Female
#>  8     8 2000-01-01 2000-01-04 NA         NA         NA         Female
#>  9     9 2000-01-01 2000-01-03 2000-01-05 2000-01-09 2000-01-12 Female
#> 10    10 2000-01-01 2000-01-05 2000-01-06 2000-01-07 2000-01-11 Female
```

Following formatting, time_spanr() can be used. This function takes the
data frame and stages specified in a list and returns the time
difference between each stage for each row.

``` r

time_span_data = time_spanr(formatted_time, example_stages)
show(time_span_data)
#> # A tibble: 10 × 11
#>       ID Stage1     Stage2     Stage3     Stage4     Stage5     Sex   
#>    <dbl> <date>     <date>     <date>     <date>     <date>     <chr> 
#>  1     1 2000-01-01 NA         NA         NA         NA         Male  
#>  2     2 2000-01-01 2000-01-03 NA         NA         NA         Male  
#>  3     3 2000-01-01 2000-01-02 2000-01-03 NA         NA         Male  
#>  4     4 2000-01-01 2000-01-04 2000-01-05 2000-01-06 NA         Male  
#>  5     5 2000-01-01 2000-01-02 2000-01-04 2000-01-07 2000-01-10 Male  
#>  6     6 NA         NA         NA         NA         NA         Female
#>  7     7 2000-01-01 NA         NA         NA         NA         Female
#>  8     8 2000-01-01 2000-01-04 NA         NA         NA         Female
#>  9     9 2000-01-01 2000-01-03 2000-01-05 2000-01-09 2000-01-12 Female
#> 10    10 2000-01-01 2000-01-05 2000-01-06 2000-01-07 2000-01-11 Female
#> # ℹ 4 more variables: `Stage1-Stage2` <drtn>, `Stage2-Stage3` <drtn>,
#> #   `Stage3-Stage4` <drtn>, `Stage4-Stage5` <drtn>
```

The result of this function is a new column for the time between each
sequential developmental stage with a new column for each developmental
period span. In order to visualise this distribution,
`visualising_time_span()` can be used. This function takes the data
frame, timespan columns and optionally a factor.

If a factor is not specified the development plot will show the
distribution across all rows.

``` r

names = c("Stage1-Stage2", "Stage2-Stage3", "Stage3-Stage4", "Stage4-Stage5")

visualising_time_span(data = time_span_data, cols = names)
#> Don't know how to automatically pick scale for object of type <difftime>.
#> Defaulting to continuous.
#> Warning: Removed 21 rows containing non-finite outside the scale range
#> (`stat_boxplot()`).
```

<img src="man/figures/README-time_spanr_example-1.png" width="100%" />

If a factor is specified a box will be shown for each variable fo the
factor at each stage.

``` r

visualising_time_span(data = time_span_data, cols = names, factor = Sex)
#> Don't know how to automatically pick scale for object of type <difftime>.
#> Defaulting to continuous.
#> Warning: Removed 21 rows containing non-finite outside the scale range
#> (`stat_boxplot()`).
```

<img src="man/figures/README-time_spanr_factor-1.png" width="100%" />
