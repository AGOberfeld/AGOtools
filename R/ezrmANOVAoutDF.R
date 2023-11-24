#' ezrmANOVAoutDF function for extracting relevant output of an rmANOVA with ezANOVA to a dataframe
#'
#' @param ezANOVAobj the input ezANOVA object
#'
#' @return rmANOVAout dataframe with relevnat statistics per effect
#' @export
#' @import dplyr
#'
#' @examples todo
ezrmANOVAoutDF=function(ezANOVAobj){
  ezANOVAobj$ANOVA$etaSq_partial <- ezANOVAobj$ANOVA$SSn/(ezANOVAobj$ANOVA$SSn+ezANOVAobj$ANOVA$SSd)
  ANOVA=ezANOVAobj$ANOVA %>% as.data.frame()
  if (exists("Sphericity Corrections",where=ezANOVAobj)) { #add sphericity corrections if applicable
    HFGG=ezANOVAobj$`Sphericity Corrections` %>% as.data.frame()
    rmANOVAout=left_join(ANOVA,HFGG,by=join_by(Effect))
  } else
  {rmANOVAout=ANOVA}
  rmANOVAout=rmANOVAout %>% mutate(dz=if_else(DFn==1,sqrt(F)/sqrt(DFd+1),NA)) #add Cohen's dz if numerator df ==1
  return(rmANOVAout)
}
