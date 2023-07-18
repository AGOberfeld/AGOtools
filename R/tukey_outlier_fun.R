#' Detect outliers according to a Tukey criterion.
#'
#' @param dv continuous dependent variable. For TTC experiments insert the estimated TTC here.
#' @param tukey_crit factor of the IQR that defines an outlier.
#'
#' @return A list of vectors.
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
  upper=Quant75+tukey_crit*IQR
  lower=Quant25-tukey_crit*IQR
  outlierTukeyLow=ifelse( dv<lower,1,0)
  outlierTukeyHigh=ifelse( dv>upper,1,0)
  outlierTukey=ifelse( outlierTukeyLow|outlierTukeyHigh,1,0)
  return_list <- list(
    "trialsInSet" = trialsInSet,
    "IQR" = IQR,
    "Quant25" = Quant25,
    "Quant75" = Quant75,
    "outlierTukeyLow" = outlierTukeyLow,
    "outlierTukeyHigh" = outlierTukeyHigh,
    "outlierTukey" = outlierTukey
  )

  # name output according to input variable:

  names(return_list) <- c(paste0(dv_str,"_",names(return_list)))

  # names(return_list) <- c(paste0(dv_str,"_","trialsInSet"),
  #                         paste0(dv_str,"_","IQR"),
  #                         paste0(dv_str,"_","Quant25"),
  #                         paste0(dv_str,"_","Quant75"),
  #                         paste0(dv_str,"_","outlierTukeyLow"),
  #                         paste0(dv_str,"_","outlierTukeyHigh"),
  #                         paste0(dv_str,"_","outlierTukey")
  #)

  return(return_list)
}

