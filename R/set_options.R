#' set_options
#'
#' Sets color palette options to matplotlib tab20 palette (default), sets global variables and loads some defauilt packages
#' @param colors choose default color palette values. Matplotlib colors are chosen by default.
#' @importFrom ggplot2 scale_colour_discrete
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
  # require(ggthemes)
  # require(extrafont)
  # require(pracma)
  # require(rlang)
  # require(colorspace)
  # require(scales)

  #show_col(tab20_colors)
  .GlobalEnv$tab20colorsSatH <- colors[seq(1, length(colors), by = 2)]
  .GlobalEnv$tab20colorsSatL <- colors[seq(2, length(colors), by = 2)]

  #set default ggplot color palette
  options(ggplot2.discrete.colour= tab20colorsSatH)
  options(ggplot2.discrete.fill = tab20colorsSatH)
  #define list of colors in the default ggplot color palette, set in .GlobalEnv$
  .GlobalEnv$ggplotColorPaletteDefault <- ggplot2::scale_color_discrete()$palette
  .GlobalEnv$ggplotColorsDefault <- ggplotColorPaletteDefault(10)

  #define default shape scale
  scale_shape_discrete <- function(...) {scale_shape_manual(values = c(15, 1, 17, 5))}

  require(knitr)
  knitr::opts_chunk$set(echo = FALSE,comment = '', fig.width = 6, fig.height = 6,dpi=300)
  #bla
  options(digits=5)
  options(download.file.method="libcurl")
  options(scipen = 999) #avoid scientific notation
  options(width = 250) # extend the width of the output

}
