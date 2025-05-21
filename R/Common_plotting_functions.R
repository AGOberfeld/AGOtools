#' @param gObj ggplot object
#' @author Daniel Oberfeld-Twistel
#' @title pShawe 
#' @return the saved then loaded image 
#' @description Saved image then loads it to ensure that the R image matches the final produced image 
#' @import DeLuciatoR
#' @import magick
#' @export
# save/show plot (ggsave_fitmax and display it in Rstudio viewer pane / markdown)
pShawe=function(gObj,maxwidth=16,
                maxheight=25,
                units="cm",
                dpi=600,
                device = "png",
                fnSuffix="", 
                imgPath=getwd(),
                ...) {
  require(DeLuciatoR)
  fName=file.path(imgPath,paste0(deparse(substitute(gObj)),fnSuffix,'.',device)) #filename = plot object name plus suffix
  
  DeLuciatoR::ggsave_fitmax(filename=fName,
                            plot=gObj,
                            maxwidth=maxwidth,
                            maxheight=maxheight,
                            units=units,
                            dpi=dpi,
                            device = device,
                            ...)
  
  require(magick)
  (img=image_read(fName))
  
  # return(list(img,fName))
  return(img)
}


#' @author Thirsa Huisman
#' @title show_plot
#' @param plot_and_plotname if no seperate_plotname is given, show_plot will try to show "plot_and_plotname" or load "plot_and_plotname.png". Use sepearte_plotname if you save the files to a different folder 
#' @param seperate_plotname Full name of the plot, eg: "saved_image.png". Needs to be used when figure is stored in subfolder (relative pathing) or other folder entirely (full pathing).  
#' @description When knitting it loads the preper saved image, when merely running the code it shows the simple plot.  
#' @export
show_plot <- function(plot_and_plotname, seperate_plotname = "") {
  if (knitr::is_latex_output() || knitr::is_html_output()) {
    if (seperate_plotname == ""){
      filename = paste0(deparse(substitute(plot_and_plotname)), ".png")
    }else{
      filename = seperate_plotname
    }
    knitr::include_graphics(filename)
  } else {
    print(plot_and_plotname)
  }
}

#' @author Thirsa Huisman
#' @title show_plot_in_loop
#' @param plot_and_plotname if no seperate_plotname is given, show_plot_in_loop will try to show "plot_and_plotname" or load "plot_and_plotname.png". Use sepearte_plotname if you save the files to a different folder 
#' @param seperate_plotname Full name of the plot, eg: "saved_image.png". Needs to be used when figure is stored in subfolder (relative pathing) or other folder entirely (full pathing).  
#' @description In block-settings ```{r, results='asis'} is required for individual plots to show up as intended. 
#' @details
#' This function outputs raw Markdown and should be used in an R Markdown chunk with the option {r, results='asis'}``` for the output to render correctly.
#' 
#' @export
show_plot_in_loop <- function(plot_and_plotname, seperate_plotname = "") {
  if (knitr::is_latex_output() || knitr::is_html_output()) {
    if (seperate_plotname == ""){
      filename = paste0(deparse(substitute(plot_and_plotname)), ".png")
    }else{
      filename = seperate_plotname
    }
    cat("![](",filename,")")
  } else {
    print(plot_and_plotname)
  }
}

#' @author Thirsa Huisman
#' @title plot_basics
#' @description This is a list of the basic plot elements that are used in most plots. 
#' @details error_bar_width needs to be scaled according to the size of the x_axis, e.g., if x goes from 0 to 10 vs 0 to 1000, you need to scale the width accordingly.
#' @param error_bar_width width of the error bars
#' @import ggplot2
#' @export 
plot_basics = function(error_bar_width = 1, point_size = 2, stroke_size = 1.5, line_width = 1, errorbar_line_width = 0.75) {
  plot_basics_list = list(stat_summary(fun = "mean", geom = "line", linewidth = line_width),
    stat_summary(fun.data = mean_se, geom = "errorbar", linewidth = errorbar_line_width, width = error_bar_width, linetype = "solid"), 
                 stat_summary(fun = "mean", geom = "point", size = point_size, stroke = stroke_size))
  return(plot_basics_list)
}


#' @author Thirsa Huisman
#' @title plot_basics
#' @description This is a list of the basic plot elements that are used in most plots, note that positiondodge can give errorbar width issues when the nr of groups per x changes. 
#' @details error_bar_width needs to be scaled according to the size of the x_axis, e.g., if x goes from 0 to 10 vs 0 to 1000, you need to scale the width accordingly.
#' @param error_bar_width width of the error bars
#' @import ggplot2
#' @export 
plot_basics_positiondodge = function(error_bar_width = 1, point_size = 2, stroke_size = 1.5, line_width = 1, errorbar_line_width = 0.75, positiondodge_width = 0) {
  plot_basics_list = list(stat_summary(fun = "mean", geom = "line", linewidth = line_width, position = position_dodge(width = positiondodge_width)),
    stat_summary(fun.data = mean_se, geom = "errorbar", linewidth = errorbar_line_width, width = error_bar_width, linetype = "solid", position = position_dodge(width = positiondodge_width)), 
                 stat_summary(fun = "mean", geom = "point", size = point_size, stroke = stroke_size, position = position_dodge(width = positiondodge_width)))
  return(plot_basics_list)
}
