#' Detect outliers according to a Tukey criterion.
#'
#' @param dv continuous dependent variable. For TTC experiments insert the estimated TTC here.
#' @param tukey_crit factor of the IQR that defines an outlier.
#'
#' @return A list of vectors:
#' * `trialsInSet` = total number of trials in the data set
#' * `IQR` = inter quantile range
#' * `Quant25` = 25% quantile
#' * `Quant75` = 75% quantile
#' * `outlierTukeyLow` = indicates if dv for a given trial is lower than the tukey criterion (1) or not (0)
#' * `Tukey_lower_limit` = lower limit below which the values are excluded
#' * `Tukey_upper_limit` = upper limit above which the values are excluded
#' @importFrom dplyr ungroup
#' @export
#'
#' @examples
#' iris |>
#' dplyr::mutate(tidyr::as_tibble(tukey_outlier_fun(dv=Petal.Length,tukey_crit=1.5)))
#'
#'
tukey_outlier_fun <- function(dv,tukey_crit=3){
  #computes outliers in variable dv according to  a Tukey criterion. Returns list of named outputs
  dv_ <- rlang::enexpr(dv)
  dv_str <- rlang::as_string(dv_)

  trialsInSet=dplyr::n() #number of trials in dv set
  IQR=stats::IQR(dv,na.rm = TRUE)
  Quant25=unname(stats::quantile(dv,probs=0.25,na.rm = TRUE))
  Quant75=unname(stats::quantile(dv,probs=0.75,na.rm = TRUE))
  Tukey_upper_limit=Quant75+tukey_crit*IQR
  Tukey_lower_limit=Quant25-tukey_crit*IQR
  outlierTukeyLow=ifelse( dv<Tukey_lower_limit,1,0)
  outlierTukeyHigh=ifelse( dv>Tukey_upper_limit,1,0)
  outlierTukey=ifelse( outlierTukeyLow|outlierTukeyHigh,1,0)
  return_list <- list(
    "trialsInSet" = trialsInSet,
    "IQR" = IQR,
    "Quant25" = Quant25,
    "Quant75" = Quant75,
    "Tukey_lower_limit"=Tukey_lower_limit,
    "Tukey_upper_limit"=Tukey_upper_limit,
    "outlierTukeyLow" = outlierTukeyLow,
    "outlierTukeyHigh" = outlierTukeyHigh,
    "outlierTukey" = outlierTukey
  )

  # name output according to input variable:

  names(return_list) <- c(paste0(dv_str,"_",names(return_list)))

  return(return_list)
}

