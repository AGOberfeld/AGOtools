% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tukey_outlier_fun.R
\name{tukey_outlier_fun}
\alias{tukey_outlier_fun}
\title{Detect outliers in one variable inside a dataframe, according to a Tukey criterion.}
\usage{
tukey_outlier_fun(dv, tukey_crit = 3)
}
\arguments{
\item{dv}{continuous dependent variable within a dataframe (does not work for vectors!!). Example: RT in a response time experiment}

\item{tukey_crit}{factor of the IQR that defines an outlier.}
}
\value{
A list of vectors:
\itemize{
\item \code{trialsInSet} = total number of trials / observations in the input dependent variable
\item \code{IQR} = inter quantile range
\item \code{Quant25} = 25\% quantile
\item \code{Quant75} = 75\% quantile
\item \code{Tukey_lower_limit} = lower limit below which the values are excluded
\item \code{Tukey_upper_limit} = upper limit above which the values are excluded
\item \code{outlierTukeyLow} = indicates if dv on a given trial is lower than Tukey_lower_limit (1) or not (0)
\item \code{outlierTukeyHigh} = indicates if dv on a given trial is higher than Tukey_upper_limit (1) or not (0)
\item \code{outlierTukey} = indicates if dv on a given trial is an outlier  according to either the upper or the lower limit (1) or not (0)
}
}
\description{
Detect outliers in one variable inside a dataframe, according to a Tukey criterion.
}
\examples{
iris |>
dplyr::mutate(tidyr::as_tibble(tukey_outlier_fun(dv=Petal.Length,tukey_crit=1.5)))


}
