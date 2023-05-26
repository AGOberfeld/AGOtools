#' plots individual psychometric functions derived from tidy quickpsy data frame.
#'
#' @param qp tidy quickpsy object (see function tidyQuickPsy)
#' @param values plotted values
#'
#' @return list of individual psychometric functions
#' @export
#' @importFrom stringr str_c str_flatten
#' @importFrom tibble deframe
#' @importFrom rlang sym
#' @importFrom ggplot2 ggplot geom_function geom_point aes labs annotate element_blank rel
#' @importFrom stats pnorm
#'
plotQuickPsy <- function(qp, # new quickpsy object (containing qp$fit and qp$tidy_fit)
                         values = c("nTrials",
                                    "sigmaEst",
                                    "se_sigmaEst",
                                    "muEst",
                                    "se_muEst",
                                    "LLRpValue"))
  { # chr. vector of values which are depicted in function plots, should correspond to column names in qp$tidy_fit

  tidy_fit <- qp$tidy_fit #df
  fit <- qp$fit #old qp object

  plot_list <- list() # prepare list for plots

  for(i in 1:nrow(tidy_fit)){ # person-condition-loop

    data <- tidy_fit$trialData[[i]] %>% as.data.frame() # unnest trialData

    # prepare plot title
    title <- str_c(fit$grouping," = ",as.character(tidy_fit[i,fit$grouping])) %>%
      str_flatten(collapse = "; ")

    # extract cum norm distr. values
    #curves <- tidy_fit$curves[[i]]


    # prepare values for depiction (annotate)
    value <- numeric()
    for(j in seq_along(values)){
      value[j] <- deframe(tidy_fit[,values[j]])[i]
    }
    # values as one chr-vector:
    plot_text <- str_c(values," = ",round(value,7))


    plot_list[[i]] <- ggplot()+
      geom_point(data = data,aes(!!sym(fit$x_str),prob,size=n),
                 color="darkred")+
      geom_function(fun = pnorm,
                    args = list(mean = data$muEst, sd = data$sigmaEst),
                    linewidth = 1.2)+
      # geom_line(data = curves,
      #           aes(x = x,
      #               y = y),
      #           color="steelblue",
      #           linewidth = 1.2)+
      labs(title = title)+
      annotate("text",
               x = max(data[[fit$x_str]])-(max(data[[fit$x_str]])-min(data[[fit$x_str]]))*0.2,
               y = -Inf,
               vjust = -0.4,
               label = str_flatten(plot_text,collapse="\n"),size=5)

  }

  return_list <- list(
    "qp" = qp,
    "plot_list" = plot_list
  )

  return(return_list)

  print(plot_list)
}
