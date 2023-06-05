
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AGOtools

<!-- badges: start -->
<!-- badges: end -->

AGOtools is an R package providing some useful tools for the
experimental research on Time-To-Collision (TTC) estimation in traffic
contexts. It is built by the Arbeitsgruppe Oberfeld from Johannes
Gutenberg-Universität Mainz, Germany.

## Project Status

This Project is currently under construction.

## Installation

Install AGOtools with:

    devtools::install_github("AGOberfeld/AGOtools")

## Dependencies

Before using AGOtools, make sure the right Quickpsy-version (dev-version
from github) is installed:

    devtools::install_github("danilinares/quickpsy")

If you have already installed the official version from CRAN, remove
quickpsy before installing it again from github.

    remove.packages("quickpsy")

    # install.packages("devtools")
    require(devtools)
    devtools::install_github("danilinares/quickpsy")

## Functions

### tukey

Adds variables to a given dataset (data) which indicate if
oberservations on a specified variable (dv) are outliers according to
the tukey criterion.

The argument tukey_crit can be used to modify the factor of the inter
quantile range (default = 3).

``` r
tukey(data = loudness_block, dv = Estimated_TTC, tukey_crit=3)
#> # A tibble: 11,040 × 20
#>    Participantnr Condition Session_code Block Trialnr Velocity Car_label  GaindB
#>    <chr>             <int>        <int> <fct>   <int> <fct>    <chr>       <dbl>
#>  1 vp001                 1            1 1          24 50       Kia_v0_50…      0
#>  2 vp001                 1            1 1          25 50       Kia_v0_50…      0
#>  3 vp001                 1            1 1          26 10       Kia_v0_10…      0
#>  4 vp001                 1            1 1          27 30       Kia_v0_30…      0
#>  5 vp001                 1            1 1          28 10       Kia_v0_10…      0
#>  6 vp001                 1            1 1          29 10       Kia_v0_10…      0
#>  7 vp001                 1            1 1          30 30       Kia_v0_30…      0
#>  8 vp001                 1            1 1          31 30       Kia_v0_30…      0
#>  9 vp001                 1            1 1          32 10       Kia_v0_10…      0
#> 10 vp001                 1            1 1          33 30       Kia_v0_30…      0
#> # ℹ 11,030 more rows
#> # ℹ 12 more variables: gainBlock1 <dbl>, loudnessVariation <chr>, TTC <dbl>,
#> #   Estimated_TTC <dbl>, vOcc <dbl>, Estimated_TTC_trialsInSet <int>,
#> #   Estimated_TTC_IQR <dbl>, Estimated_TTC_Quant25 <dbl>,
#> #   Estimated_TTC_Quant75 <dbl>, Estimated_TTC_outlierTukeyLow <dbl>,
#> #   Estimated_TTC_outlierTukeyHigh <dbl>, Estimated_TTC_outlierTukey <dbl>

# OR:

loudness_block %>%
    tukey(Estimated_TTC)
#> # A tibble: 11,040 × 20
#>    Participantnr Condition Session_code Block Trialnr Velocity Car_label  GaindB
#>    <chr>             <int>        <int> <fct>   <int> <fct>    <chr>       <dbl>
#>  1 vp001                 1            1 1          24 50       Kia_v0_50…      0
#>  2 vp001                 1            1 1          25 50       Kia_v0_50…      0
#>  3 vp001                 1            1 1          26 10       Kia_v0_10…      0
#>  4 vp001                 1            1 1          27 30       Kia_v0_30…      0
#>  5 vp001                 1            1 1          28 10       Kia_v0_10…      0
#>  6 vp001                 1            1 1          29 10       Kia_v0_10…      0
#>  7 vp001                 1            1 1          30 30       Kia_v0_30…      0
#>  8 vp001                 1            1 1          31 30       Kia_v0_30…      0
#>  9 vp001                 1            1 1          32 10       Kia_v0_10…      0
#> 10 vp001                 1            1 1          33 30       Kia_v0_30…      0
#> # ℹ 11,030 more rows
#> # ℹ 12 more variables: gainBlock1 <dbl>, loudnessVariation <chr>, TTC <dbl>,
#> #   Estimated_TTC <dbl>, vOcc <dbl>, Estimated_TTC_trialsInSet <int>,
#> #   Estimated_TTC_IQR <dbl>, Estimated_TTC_Quant25 <dbl>,
#> #   Estimated_TTC_Quant75 <dbl>, Estimated_TTC_outlierTukeyLow <dbl>,
#> #   Estimated_TTC_outlierTukeyHigh <dbl>, Estimated_TTC_outlierTukey <dbl>
```

Returns a list of variables and adds them to the initial data set:

`trialsInSet` = total number of trials in the data set  
`IQR` = inter quantile range  
`Quant25` = 25% quantile  
`Quant75` = 75% quantile  
`outlierTukeyLow` = indicates if dv for a given trial is lower than the
tukey criterion (1) or not (0)  
`outlierTukeyHigh` = indicates if dv for a given trial is higher than
the tukey criterion (1) or not (0)  
`outlierTukey` = indicates if dv for a given trial exceeds the lower or
the higher criterion (1) or is within both criteria (0)

### tidyQuickPsy

Takes a quickpsy-object and turns it into a tibble.

Use the following arguments in the quickpsy function:  
`d` = data  
`x` = Name of the explanatory variable (e.g. TTC)  
`k` = Name of the response variable.  
`n` = number of trials  
`grouping` = concatinated vector of the variables that define the
experimental conditions + partipiant code variable

    qp <- quickpsy(d = data,  
                    x = var_expl, 
                    k = var_response, 
                    n = nTrials,  
                    grouping = c("vp_code","modality","v0","a","label","gain"),  
                    fun=cum_normal_fun,  
                    guess=0,  
                    lapses=0,  
                    bootstrap = 'none')  

    qp_tidy <- tidyQuickPsy(qp)

tidyQuickPsy returns a list with two elements:  
- `qp_tidy$qp` is the “old” quickpsy object - `qp_tidy$tidy_fit` is a
tidy tibble containing the most important statistics of the quickpsy
object.

### plotQuickPsy

Takes an object produced by tidyQuickPsy and plots the resulting
psychometric functions for each person separately.

    qp <- quickpsy(d = data,  
                    x = var_expl, 
                    k = var_response, 
                    n = nTrials,  
                    grouping = c("vp_code","modality","v0","a","label","gain"),  
                    fun=cum_normal_fun,  
                    guess=0,  
                    lapses=0,  
                    bootstrap = 'none')  

    qp_tidy <- tidyQuickPsy(qp)

    plotQuickPsy(qp_tidy)

### plotThemeAGO

Plot theme for classic TTC plots.
