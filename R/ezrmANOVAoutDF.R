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
    rmANOVAout = rmANOVAout %>% mutate( # make sure pGG and pHF have values for all effects
        `p[HF]` = ifelse(is.na(`p[HF]`), p, `p[HF]`),
        `p[HF]<.05`=ifelse(is.na(`p[HF]<.05`), `p<.05`, `p[HF]`),
        `p[GG]` = ifelse(is.na(`p[GG]`), p, `p[GG]`),
        `p[GG]<.05`=ifelse(is.na(`p[GG]<.05`), `p<.05`, `p[GG]`)
    )
  } else
  {rmANOVAout=ANOVA}

  return(rmANOVAout)
}
