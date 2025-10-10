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
        `p[HF]<.05`=ifelse(is.na(`p[HF]<.05`), `p<.05`, `p[HF]<.05`),
        `p[GG]` = ifelse(is.na(`p[GG]`), p, `p[GG]`),
        `p[GG]<.05`=ifelse(is.na(`p[GG]<.05`), `p<.05`, `p[GG]<.05`)
    )
  } else
  {
    rmANOVAout=ANOVA
    rmANOVAout = rmANOVAout %>% mutate( # make sure pGG and pHF have values for all effects
      `p[HF]` =  p,
      `p[HF]<.05`=`p<.05`,
      `p[GG]` =  p,
      `p[GG]<.05`= `p<.05`,
      GGe = NA,
      HFe=NA
    )
    }

  return(rmANOVAout)
}

#' @author Thirsa Huisman
#' @title add_dz_to_ANOVA_table
#' @export
add_dz_to_ANOVA_table <- function(no_dz_anova, nwithin){
  cat(sprintf("Adding dz to ANOVA table with nwithin = %s\n", nwithin))
  no_dz_anova_no_intercept <- no_dz_anova %>%
    mutate(dz = ifelse(DFn == 1, sqrt(F)/sqrt(nwithin), NA))
}

#' @author Thirsa Huisman
#' @title add_d_to_ANOVA_table
#' @export
add_d_to_ANOVA_table <- function(no_d_anova, nbetween){
  cat(sprintf("Adding d to ANOVA table with nbetween = %s\n", nbetween))
  no_d_anova_no_intercept <- no_d_anova %>%
    mutate(d = ifelse(DFn == 1, sqrt(F)*sqrt(2/nbetween), NA))
}


#' @author Thirsa Huisman
#' @title format_ANOVA_table
#' @param ezanovaObject object created by ezANOVA
#' @param add_dz add Cohen's dz to the table (!! valid only for within-subject effects, not checked by function!)

#' @export
#' @import formattable
#' @return formattable object with formatted ANOVA table

format_ANOVA_table <- function(ezANOVAobject, add_dz = TRUE, participant_column_name = "Participantnr"){
  anova_output_clean = ezrmANOVAoutDF(ezANOVAobject)
  # select columns
  ## with huynh-feldt
  if ("p[HF]" %in% colnames(anova_output_clean)){
    selected_column_names = c("Effect", "F", "DFn", "DFd", "HFe", "p", "etaSq_partial")
    anova_output_clean <- anova_output_clean %>% mutate(corrected_p = ifelse(is.na(`p[HF]`), `p`, `p[HF]`))%>%
      select(-p)%>% rename(`p` = corrected_p)
  }else{ ##without huynh-feldt
    selected_column_names = c("Effect", "F", "DFn", "DFd", "p", "etaSq_partial")}

  # filter out intercept and select columns
  anova_table_unformatted <- anova_output_clean %>% filter(Effect != "(Intercept)") %>%
    select(selected_column_names)

  # add dz
  if (add_dz){
    aov = ezanova_output$aov[[participant_column_name]]
    nsubjects = length(aov$fitted.values) + 1
    anova_table_unformatted = add_dz_to_ANOVA_table(anova_table_unformatted, nsubjects)
  }
  anovaOutputFmttab<- anova_table_unformatted %>%  mutate_if(is.numeric, round, digits=3)
  anovaOutput_char <- anovaOutputFmttab
  anovaOutput_char$p[anovaOutputFmttab$p == 0] = sprintf("<0.001")

  p_formatter <- formatter("span", style = x ~ ifelse(x == "<0.001",
                                                      style(font.weight = "bold"),
                                                      ifelse(as.numeric(x) <= 0.05,
                                                             style(font.weight = "bold"),
                                                             NA))
  )
  anovaOutputFormat=formattable(anovaOutput_char, list(area(col="p") ~ p_formatter))
  anovaOutputFormat$Effect <- gsub(":", " × ", anovaOutputFormat$Effect)
  # replace NA values with empty space
  if ("HFe" %in% colnames(anovaOutputFormat)){
    anovaOutputFormat$HFe[is.na(anovaOutputFormat$HFe)] = ""
  }
  if ("dz" %in% colnames(anovaOutputFormat)){
    anovaOutputFormat$dz[is.na(anovaOutputFormat$dz)] = ""
  }
  return(anovaOutputFormat)
}

#' @author Thirsa Huisman
#' @title main_and_subscript
#' @export
main_and_subscript <- function(main, subscript){
  paste0(main, "<sub>", subscript, "</sub>")
}

#' @author Thirsa Huisman
#' @title italic_main_and_subscript
#' @export
italic_main_and_subscript <- function(main, subscript = ""){
  paste0("<i>", main, "<i>","<i>","<sub>", subscript, "</sub></i>")
}


# examples for further formatting:

#anovaOutputFormat = anovaOut
#anovaOutputFormat$Effect <- gsub("TTC_s_intended", "TTC_s", anovaOutputFormat$Effect)
#anovaOutputFormat$Effect <- gsub("LAeqFinal", main_and_subscript("L", "Aeq"), anovaOutputFormat$Effect)
#anovaOutputFormat$Effect <- gsub("Docc", italic_main_and_subscript("D", "Occ"), anovaOutputFormat$Effect)
#anovaOutputFormat$Effect <- gsub("a", italic_main_and_subscript("a"), anovaOutputFormat$Effect)  # makes single letter italic
#anovaOutputFormat

