#' set_options
#'
#' Sets color palette options to the Matplotlib tab20 palette (default), sets global variables
#' @param colors choose default color palette values. Matplotlib colors are chosen by default.
#' @importFrom ggplot2 scale_color_discrete scale_shape_manual
#' @import knitr
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
                                         '#9edae5')){

  #load default packages
  require(tidyverse)
  require(pracma)
  require(rlang)
  require(extrafont)
  # require(ggthemes)
  # require(colorspace)
  # require(scales)

  #show_col(tab20_colors)
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

  #require(knitr)
  knitr::opts_chunk$set(echo = FALSE,comment = '', out.width = "80%",dpi=200)
  #set some options for output
  options(digits=5)
  options(download.file.method="libcurl")
  options(scipen = 999) #avoid scientific notation
  options(width = 250) # extend the width of the output

  # set geom options
  update_geom_defaults("line", aes(linewidth = 2))
  update_geom_defaults("point", aes(size = 5)) # for unicode: 9
  update_geom_defaults("errorbar", aes(linewidth = 1, width = 0.3))
}
