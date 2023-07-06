#' set_options
#'
#' Sets color palette options to matplotlib colors.
#' @param colors choose default color palette values. Matplotlib colors are chosen by default.
#' @importFrom ggplot2 scale_colour_discrete
#'
#' @return a list containing quickpsy objects for each participant.
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

#show_col(tab20_colors)
tab20colorsSatH <- colors[seq(1, length(colors), by = 2)]
tab20colorsSatL <- colors[seq(2, length(colors), by = 2)]

#set default ggplot color palette
options(ggplot2.discrete.colour= tab20colorsSatH)
#define list of colors in the default ggplot color palette
ggplotColorPaletteDefault <- ggplot2::scale_color_discrete()$palette
ggplotColorsDefault <- ggplotColorPaletteDefault(10)
options(ggplot2.discrete.fill = tab20colorsSatH)

#define default shape scale
scale_shape_discrete <- function(...) {
  scale_shape_manual(values = c(15, 1, 17, 5))
}
}
