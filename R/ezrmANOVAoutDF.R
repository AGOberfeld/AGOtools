#' ezrmANOVAoutDF Function for extracting relevant output of an rmANOVA conducted with ezANOVA to a dataframe
#'
#' @param ezANOVAobj the input ezANOVA object
#'
#' @return rmANOVAout: dataframe with relevant statistics per effect
#' @export
#' @import dplyr

ezrmANOVAoutDF=function(ezANOVAobj){
  ezANOVAobj$ANOVA$etaSq_partial <- ezANOVAobj$ANOVA$SSn/(ezANOVAobj$ANOVA$SSn+ezANOVAobj$ANOVA$SSd) # compute partial eta squared
  ANOVA=ezANOVAobj$ANOVA %>% as.data.frame()
  if (exists("Sphericity Corrections",where=ezANOVAobj)) { #add sphericity corrections if applicable
    HFGG=ezANOVAobj$`Sphericity Corrections` %>% as.data.frame()
    rmANOVAout=left_join(ANOVA,HFGG,by=join_by(Effect))
    rmANOVAout = rmANOVAout %>% mutate(`p[HF]` = ifelse(is.na(`p[HF]`), `p`, `p[HF]`),`p[HF]` = ifelse(is.na(`p[GG]`), `p`, `p[GG]`))
  } else
  {rmANOVAout=ANOVA}

  return(rmANOVAout)
}
