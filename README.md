# AGOtools




## Installation

* Download the entire project (download button on the right-hand side).
* Open the file AGOtools.Rproj
* make sure devtools is loaded
```
require(devtools)
```
* Execute the command:
```
install()
```
* AGOtools will now be installed on your system.

## Dependencies

Before using AGOtools, make sure the right Quickpsy-version (dev-version from github) is installed. If you have already installed the official version from CRAN, remove quickpsy before installing it again from github.

```
remove.packages("quickpsy")

# install.packages("devtools")
require(devtools)
devtools::install_github("danilinares/quickpsy")

```

## Functions

### tukey

Adds variables to a given dataset (data) which indicate if oberservations on a specified variable (dv) are outliers according to the tukey criterion.

The argument tukey_crit can be used to modify the factor of the inter quantile range (default = 3).

```
tukey(data = outlier_testdata, dv = x, tukey_crit=3)

# OR:

outlier_testdata %>%
	tukey(x)
```

Returns a list of variables and adds them to the initial data set:

`trialsInSet` = total number of trials in the data set
`IQR` = inter quantile range  
`Quant25` = 25% quantile  
`Quant75` = 75% quantile  
`outlierTukeyLow` = indicates if dv for a given trial is lower than the tukey criterion (1) or not (0)  
`outlierTukeyHigh` = indicates if dv for a given trial is higher than the tukey criterion (1) or not (0)   
`outlierTukey` = indicates if dv for a given trial exceeds the lower or the higher criterion (1) or is within both criteria (0)

### tidyQuickPsy

Takes a quickpsy-object and turns it into a tibble.

Use the following arguments in the quickpsy function:   
`d` = data  
`x` = Name of the explanatory variable (e.g. TTC)  
`k` = Name of the response variable.  
`n` = number of trials   
`grouping` = concatinated vector of the variables that define the experimental conditions + partipiant code variable



```
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
```
tidyQuickPsy returns a list with two elements:  
-   `qp_tidy$qp` is the "old" quickpsy object
-   `qp_tidy$tidy_fit` is a tidy tibble containing the most important statistics of the quickpsy object.


### plotQuickPsy

Takes a tidy tibble (produced by tidyQuickPsy) and plots the resulting psychometric functions for each person separately.

### plotThemeAGO

Plot theme for classic TTC plots.

