#' Complete plot theme for publication-ready data plots
#' @param base_size base size
#' @param base_family base font family, default = Arial Unicode MS
#'
#' @export
#'
#'
#' @importFrom dplyr %>%
#' @importFrom ggplot2 aes ggplot theme element_text element_rect element_line unit margin scale_color_discrete scale_shape_manual geom_point scale_color_manual scale_shape_manual scale_fill_manual
#' @importFrom ggthemes theme_foundation
#'
plotThemeAGO <- function(base_size=12, base_family="Arial",...) {

  list(ggthemes::theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(0.8)), #hjust = 0.5
            text = element_text(),
            plot.background = element_rect(fill = NULL,colour = NULL),
            panel.background = element_rect(fill = NULL,colour = NULL),
            plot.caption = element_text(size =  rel(1)),
            #panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.major =element_blank(),
            panel.grid.minor = element_blank(),
            panel.spacing    = unit(0, "mm"),
            panel.border = element_rect(colour = "black", fill = NA),
            plot.margin=margin(t = 1, r = 1, b = 1, l = 1, unit = "mm"), #unit(c(2,2,2,2),"mm"),
            axis.title = element_text(face = "bold",size = rel(0.8)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(),
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            legend.position = "inside",
            legend.position.inside = c(0.05,0.95),
            legend.direction = "horizontal",
            legend.margin=margin(t = 1, r = 1, b = 1, l = 1, unit = "mm"),
            legend.key = element_rect(colour = NA),
            legend.key.size= unit(0.2, "cm"),
            legend.title = element_text(face="italic",size=rel(0.8)),
            strip.background = element_blank(),
            strip.text = element_text(face="bold"),...),
     scale_shape_manual(values = c(15, 1, 17, 5,2,5,7)) # set default sequence of shapes
    )

}
