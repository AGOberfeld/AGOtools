#' nestByAddGroupKey
#'
#' nests a dataframe by grouping vars “groupVars”
#' (vector of strings, e.g., groupVars=c("Subj","Condition"))
#' and adds a string variable "groupKey" indicating the group vars combination
#' to the "data" list object
#'
#' @param dataframe dataframe to be nested
#' @param groupVars grouping variable as character string
#'
#' @return data.frame containing nested data
#' @export
#'
#' @examples
#' iris %>%
#'   nestByAddGroupKey("Species")
#'
#' @importFrom tidyr unite all_of nest
#' @importFrom dplyr %>% group_by across
#' @import magrittr
#'
nestByAddGroupKey <- function(dataframe,groupVars){

  nestedDF <- dataframe %>% unite("groupKey",all_of(groupVars),sep = "_",remove=FALSE) #add string variable indicating the group vars combination to the dataframe

  nestedDF <- nestedDF%>%group_by(across(all_of(groupVars)))

  nestedDF <- nestedDF  %>% nest()

  return(nestedDF)

}

