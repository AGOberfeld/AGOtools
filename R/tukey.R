#' Detect outlier according to the tukey criterion.
#'
#' @param data data frame to apply the tukey outlier analysis on.
#' @param dv variable to apply the tukey outlier analysis on.
#' @param tukey_crit factor of the IQR that defines an outlier.
#' @param exclude logical indicating if outliers should be excluded (default = FALSE).
#' @return data frame including new variables concerning tukey outlier analysis.
#' @export
#'
#' @examples
#' tukey(iris,Petal.Length)
#'
#' @import dplyr
#' @import rlang
#' @import tidyr


tukey <- function(data,dv,tukey_crit=3,exclude = F){

  dv_ <- rlang::enexpr(dv)
  dv_str <- rlang::as_string(dv_)

  data <- data %>%
    dplyr::mutate(tidyr::as_tibble(tukey_outlier_fun(dv=!!sym(dv_str),
                                                     tukey_crit=tukey_crit)))

  if(exclude){

    data <- data %>%
      filter(!!sym(paste0(dv_str,"_outlierTukeyHigh")) != 1 &
               !!sym(paste0(dv_str,"_outlierTukeyLow")) != 1 )
  }


  return(data)

}

