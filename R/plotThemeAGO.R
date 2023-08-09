
#' Complete plot theme for publication-ready data plots
#' @param base_size base size
#' @param base_family base font family, default = Arial Unicode MS
#'
#' @export
#'
#'
#'
#' @importFrom dplyr %>%
#' @importFrom ggplot2 aes ggplot theme element_text element_rect element_line unit margin scale_color_discrete scale_shape_manual geom_point scale_color_manual scale_shape_manual scale_fill_manual
#' @import extrafont
#' @importFrom ggthemes theme_foundation
#'
plotThemeAGO <- function(base_size=12, base_family="Arial") {

  list(ggthemes::theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(0.8), hjust = 0.5),
            text = element_text(),
            plot.background = element_rect(colour = NA),
            plot.caption = element_text(size =  rel(1)),
            panel.background = element_rect(colour = NA),
            #panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.major =element_blank(),
            panel.grid.minor = element_blank(),
            panel.spacing    = unit(0, "mm"),
            panel.border = element_rect(colour = "black", fill = NA),
            plot.margin=unit(c(5,5,5,5),"mm"), #margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")
            axis.title = element_text(face = "bold",size = rel(0.8)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(),
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(0.21, "cm"),
            legend.margin=margin(t = 3, r = 3, b = 0, l = 0, unit = "mm"),
            legend.title = element_text(face="italic",size=rel(0.8)),
            strip.background = element_blank(),
            strip.text = element_text(face="bold")),
     scale_shape_manual(values = c(15, 1, 17, 5,2,5,7))
    )

}

##-- moved to set_option():
# Define the matplotlib tab20 palette
#tab20colors = c( '#1f77b4','#aec7e8','#ff7f0e','#ffbb78','#2ca02c','#98df8a','#d62728','#ff9896','#9467bd','#c5b0d5','#8c564b','#c49c94','#e377c2','#f7b6d2','#7f7f7f','#c7c7c7','#bcbd22','#dbdb8d','#17becf','#9edae5')
#show_col(tab20_colors)
#tab20colorsSatH = tab20colors[seq(1, length(tab20colors), by = 2)]
#tab20colorsSatL = tab20colors[seq(2, length(tab20colors), by = 2)]

#set default ggplot color palette
#options(ggplot2.discrete.colour= tab20colorsSatH)
#define list of colors in the default ggplot color palette
#ggplotColorPaletteDefault=ggplot2::scale_color_discrete()$palette
#ggplotColorsDefault=ggplotColorPaletteDefault(10)
#options(ggplot2.discrete.fill= tab20colorsSatH)

#define default shape scale
# scale_shape_discrete = function(...) {
#   scale_shape_manual(values = c(15, 1, 17, 5))
# }

