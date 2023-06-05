#' converts a quickpsy object into a tidy tibble
#'
#' @param fit quickpsy object
#'
#' @return a list containing the original quickpsy object (fit) and the tibble version (tidy_fit)
#' @export
#' @importFrom dplyr mutate case_when select starts_with group_by summarise n rename left_join
#' @importFrom rlang syms
#' @importFrom tidyr pivot_wider nest
#' @importFrom stats pchisq
#'
#'
tidyQuickPsy <- function(fit){

  suppressMessages(

  df <- fit$par %>%
    mutate(par_name = case_when( # rename parameters
      parn == "p1" ~ "muEst",
      parn == "p2" ~ "sigmaEst"
    )) %>%
    select(-parn) %>%
    pivot_wider(names_from=par_name,values_from=c(par,parinf,parsup,se)) %>%
    select(- starts_with(c("parinf","parsup"))) %>%
    left_join(fit$averages %>%  # add number of trials
                group_by(!!!syms(fit$grouping)) %>%
                summarise(nTrials=sum(n))) %>%
    left_join(fit$deviance %>% # add deviance and Chi²-test
                rename("LLRtestvalue" = deviance,
                       "LLRtestDF" = df) %>%
                mutate("LLRpValue" = 1-pchisq(q = LLRtestvalue, df = LLRtestDF))) %>%
    left_join(fit$logliks %>% # add loglikelihoods and LL saturated
                rename("LL" = loglik,"nParFittedModel"=n_par)) %>%
    left_join(fit$loglikssaturated %>%
                rename("LLsaturated" = loglik,"nParSaturatedModel"=n_par)) %>%
    rename("muEst"=par_muEst,
           "sigmaEst"=par_sigmaEst) %>%
    left_join(fit$averages %>%
                left_join(fit$par %>%
                            mutate(par_name = case_when(
                              parn == "p1" ~ "muEst",
                              parn == "p2" ~ "sigmaEst"
                            )) %>%
                            select(par_name,par) %>%
                            pivot_wider(names_from=par_name,values_from=par)) %>%
                group_by(!!!syms(fit$grouping)) %>%
                nest(.key = "trialData")) #%>%
  # left_join(fit$curves %>%# add cum normal function values as nested list -> plots per person condition combination
  #             group_by(!!!syms(fit$grouping)) %>%
  #             nest(.key="curves"))

  )

  return_list <- list(
    fit = fit, # old quickpsy-object (list)
    tidy_fit = df # new data frame
  )

  return(return_list)

}
