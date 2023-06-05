#' Detect outlier according to the tukey criterion.
#'
#' @param data data frame.
#' @param dv continuous dependent variable AS VECTOR. For TTC experiments insert the estimated TTC here.
#' @param tukey_crit factor of the IQR that defines an outlier.
#'
#' @return A list of vectors.
#' @export
#'
#' @examples
#' iris |>
#' dplyr::mutate(tidyr::as_tibble(tukey_outlier_fun(dv=Petal.Length,tukey_crit=3)))
#'
#'
tukey_outlier_fun2 <-function(data,dv,tukey_crit=3){
  #computes outliers in variable dv according to  a Tukey criterion. Returns list of named outputs
  #number of trials in dv set
  #browser()

  dv_ <- rlang::enexpr(dv)
  dv_str <- rlang::as_string(dv_)

  # if(is.character(dv)){
  #   dv_str <- dv
  # }

  dv_vec <- data[[dv_str]]
  # dv_ <- rlang::enexpr(dv)
  # dv_str <- paste0(rlang::as_string(dv_),"_")

  trialsInSet = length(dv_vec)
  IQR=stats::IQR(dv_vec,na.rm = TRUE)
  Quant25=unname(stats::quantile(dv_vec,probs=0.25,na.rm = TRUE))
  Quant75=unname(stats::quantile(dv_vec,probs=0.75,na.rm = TRUE))
  upper=Quant75+tukey_crit*IQR
  lower=Quant25-tukey_crit*IQR
  outlierTukeyLow=ifelse(dv_vec<lower,1,0)
  outlierTukeyHigh=ifelse(dv_vec>upper,1,0)
  outlierTukey=ifelse(outlierTukeyLow|outlierTukeyHigh,1,0)
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



  return(return_list)
}
