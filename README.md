
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

Identify outliers without excluding them:

``` r
tukey(data = loudness_block, 
      dv = Estimated_TTC, 
      tukey_crit=3, 
      exclude = FALSE)
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

Identify outliers and exclude them:

``` r
loudness_block %>%
    tukey(Estimated_TTC, 
          exclude = TRUE)
#> # A tibble: 10,784 × 20
#>    Participantnr Condition Session_code Block Trialnr Velocity Car_label  GaindB
#>    <chr>             <int>        <int> <fct>   <int> <fct>    <chr>       <dbl>
#>  1 vp001                 1            1 1          24 50       Kia_v0_50…      0
#>  2 vp001                 1            1 1          27 30       Kia_v0_30…      0
#>  3 vp001                 1            1 1          28 10       Kia_v0_10…      0
#>  4 vp001                 1            1 1          32 10       Kia_v0_10…      0
#>  5 vp001                 1            1 1          33 30       Kia_v0_30…      0
#>  6 vp001                 1            1 1          34 30       Kia_v0_30…      0
#>  7 vp001                 1            1 1          36 10       Kia_v0_10…      0
#>  8 vp001                 1            1 1          37 10       Kia_v0_10…      0
#>  9 vp001                 1            1 1          38 50       Kia_v0_50…      0
#> 10 vp001                 1            1 1          39 50       Kia_v0_50…      0
#> # ℹ 10,774 more rows
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

``` r
data <- streetcrossing %>% 
  filter(vp_code %in% c("vp0001","vp0002","vp0004"))

qp <- quickpsy(d = data,  
                x = track_TTC, 
                k = nCross, 
                n = nTrials,  
                grouping = c("vp_code","modality","v0","a","label","gain"),  
                fun=cum_normal_fun,  
                guess=0,  
                lapses=0,  
                bootstrap = 'none')  
#> Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
#> dplyr 1.1.0.
#> ℹ Please use `reframe()` instead.
#> ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
#>   always returns an ungrouped data frame and adjust accordingly.
#> ℹ The deprecated feature was likely used in the quickpsy package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.

qp_tidy <- tidyQuickPsy(qp)
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`
#> Adding missing grouping variables: `vp_code`, `modality`, `v0`, `a`, `label`,
#> `gain`
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`
#> Joining with `by = join_by(vp_code, modality, v0, a, label, gain)`

qp_tidy$tidy_fit
#> # A tibble: 40 × 20
#> # Groups:   vp_code, modality, v0, a, label, gain [40]
#>    vp_code modality    v0     a label   gain muEst sigmaEst se_muEst se_sigmaEst
#>    <chr>   <chr>    <dbl> <int> <chr>  <int> <dbl>    <dbl>    <dbl>       <dbl>
#>  1 vp0001  A         10       2 Kia_v…     0  4.14    1.19     0.176       0.292
#>  2 vp0001  A         10       2 Kia_v…    10  6.37    0.948    0.167       0.190
#>  3 vp0001  A         30       0 Kia_v…     0  1.56    0.927    0.159       0.190
#>  4 vp0001  A         30       0 Kia_v…    10  5.03    2.09     0.323       0.472
#>  5 vp0001  A         49.6     0 Kia_v…     0  2.46    2.20     0.345       0.461
#>  6 vp0001  A         49.6     0 Kia_v…    10  4.78    2.52     0.392       0.553
#>  7 vp0001  A         60       0 Kia_v…     0  2.41    1.08     0.167       0.248
#>  8 vp0001  A         60       0 Kia_v…    10  5.37    1.94     0.311       0.424
#>  9 vp0001  AV        10       2 Kia_v…     0  3.60    0.820    0.137       0.159
#> 10 vp0001  AV        10       2 Kia_v…    10  4.60    1.31     0.212       0.263
#> # ℹ 30 more rows
#> # ℹ 10 more variables: nTrials <int>, LLRtestvalue <dbl>, LLRtestDF <int>,
#> #   p_value <dbl>, LLRpValue <dbl>, LL <dbl>, nParFittedModel <int>,
#> #   LLsaturated <dbl>, nParSaturatedModel <int>, trialData <list>
```

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

### Data sets

``` r
data("loudness_block")
loudness_block
#> # A tibble: 11,040 × 13
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
#> # ℹ 5 more variables: gainBlock1 <dbl>, loudnessVariation <chr>, TTC <dbl>,
#> #   Estimated_TTC <dbl>, vOcc <dbl>

data("streetcrossing")
streetcrossing
#> # A tibble: 2,771 × 10
#>    vp_code label       modality    v0     a  gain track_TTC nTrials nCross vp   
#>    <chr>   <chr>       <chr>    <dbl> <int> <int>     <dbl>   <int>  <int> <chr>
#>  1 vp0001  Kia_v0_10_… A           10     2     0      2.86       6      0 Kia_…
#>  2 vp0001  Kia_v0_10_… A           10     2     0      3          1      1 Kia_…
#>  3 vp0001  Kia_v0_10_… A           10     2     0      3.29       6      2 Kia_…
#>  4 vp0001  Kia_v0_10_… A           10     2     0      3.34       3      2 Kia_…
#>  5 vp0001  Kia_v0_10_… A           10     2     0      3.78      10      1 Kia_…
#>  6 vp0001  Kia_v0_10_… A           10     2     0      3.85      16      6 Kia_…
#>  7 vp0001  Kia_v0_10_… A           10     2     0      4.35       6      4 Kia_…
#>  8 vp0001  Kia_v0_10_… A           10     2     0      4.42       9      7 Kia_…
#>  9 vp0001  Kia_v0_10_… A           10     2     0      5         14      9 Kia_…
#> 10 vp0001  Kia_v0_10_… A           10     2     0      5.09       7      6 Kia_…
#> # ℹ 2,761 more rows
```
