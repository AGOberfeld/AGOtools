% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/safe_quickpsy.R
\name{safe_quickpsy}
\alias{safe_quickpsy}
\title{safe_quickpsy}
\usage{
safe_quickpsy(part_id, data, x, k, n, grouping)
}
\arguments{
\item{part_id}{variable that encodes the participant numbers.}

\item{data}{data frame.}

\item{x}{explanatory variable.}

\item{k}{response variable.}

\item{n}{number of trials.}

\item{grouping}{grouping varibale as c("var1","var",...).}
}
\value{
a list containing quickpsy objects for each participant.
}
\description{
workaround to prevent quickpsy from stopping if hessian matrix is not solvable.
for parameter information see \code{?quickpsy}.
}
\examples{
safe_quickpsy(data = streetcrossing,
              part_id = vp_code,
              x = track_TTC,
              k = nCross,
              n = nTrials,
              grouping = c("vp_code","modality","v0","a","label","gain"))

}
