#' set_options
#'
#' Sets color palette options to the Matplotlib tab20 palette (default), sets global variables
#' @param colors choose default color palette values. Matplotlib colors are chosen by default.
#' @param line_width choose default line width for geom_line
#' @param point_size choose default point size fpr geom_point
#' @import ggplot2 knitr
#' @import DeLuciatoR
#'
#' @return void
#' @export
#' @examples
#' set_options()
#'

set_options <- function(colors = c( '#1f77b4',
                                         '#aec7e8',
                                         '#ff7f0e',
                                         '#ffbb78',
                                         '#2ca02c',
                                         '#98df8a',
                                         '#d62728',
                                         '#ff9896',
                                         '#9467bd',
                                         '#c5b0d5',
                                         '#8c564b',
                                         '#c49c94',
                                         '#e377c2',
                                         '#f7b6d2',
                                         '#7f7f7f',
                                         '#c7c7c7',
                                         '#bcbd22',
                                         '#dbdb8d',
                                         '#17becf',
                                         '#9edae5'),
                        line_width = rel(1),
                        point_size = rel(2)){

  #load default packages
  require(tidyverse)
  require(pracma)
  require(rlang)
  require(extrafont)
  #font_import() # imports Win fonts -> needs to be run only one per computer
  #extrafont::loadfonts() # required only once after font_import()
  # install_github("infotroph/DeLuciatoR")
  require(DeLuciatoR) # for saving plots with ggsave_fitmax

  # set R language to English
  Sys.setenv(LANG = "en")

  options(dplyr.summarise.inform = FALSE) #turn off summarise "grouped output by" messages


  # set default linewidth (geom_line) and point size (geom_point)
  update_geom_defaults("line", aes(linewidth = line_width))
  update_geom_defaults("point", aes(size = point_size))

  update_geom_defaults("errorbar", aes(linewidth = rel(0.5), width = rel(0.1)))
  # set geom options
  # update_geom_defaults("line", aes(linewidth = 2))
  # update_geom_defaults("point", aes(size = 5)) # for unicode: 9

  #Define color palette show_col(tab20_colors)
  .GlobalEnv$tab20colorsSatH <- colors[seq(1, length(colors), by = 2)]
  .GlobalEnv$tab20colorsSatL <- colors[seq(2, length(colors), by = 2)]
  .GlobalEnv$tab20colors=c(.GlobalEnv$tab20colorsSatH,.GlobalEnv$tab20colorsSatL)

  #set default ggplot color palette
  options(ggplot2.discrete.colour= .GlobalEnv$tab20colors)
  options(ggplot2.discrete.fill = .GlobalEnv$tab20colors)
  #define list of colors in the default ggplot color palette, set in .GlobalEnv$
  .GlobalEnv$ggplotColorPaletteDefault <- ggplot2::scale_color_discrete()$palette
  .GlobalEnv$ggplotColorsDefault <- ggplotColorPaletteDefault(10)

  # #define default shape scale
  # scale_shape_discrete <- function(...) {scale_shape_manual(values = c(15, 1, 17, 5))}

  #Set knitr defaults
  knitr::opts_chunk$set(dev="png", error=T,echo = T,comment = '')
  #set some options for output
  options(digits=5)
  options(download.file.method="libcurl")
  options(scipen = 999) #avoid scientific notation
  options(width = 250) # extend the width of the output

}
