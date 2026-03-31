#' Check a dataframe prior to running a repeated-measures ANOVA. Detects and removes subjects with empty cells, and issues warning if there are cells containing more than one observation
#'
#' @param df input dataframe
#' @param subjIDstr Name of the column identifying the subjects (string), e.g., "subjCode".
#' @param factorsStr Vector of column names of the factors in the rmANOVA (character vector), e.g., c("Condition","Time")
#' @param verbose logical (default = FALSE).
#' @return `nEmptyCells` = number of empty cells
#' @return `df_nonEmpty` = data frame where subjects with empty cells are removed
#' @return `maxObsPerCell` = maximum number of observations in df_nonEmpty per cell (must be 1 for an rmANOVA)
#' @importFrom dplyr group_by mutate filter ungroup distinct select arrange across all_of
#' @importFrom tidyr complete
#' @importFrom rlang syms
#' @importFrom knitr kable
#' @export

rmANOVAcellCheck=function(df,subjIDstr,factorsStr,verbose=F) {
  if (verbose) {
    cat("\nChecking df for rmANOVA.\nSubject ID variable: ",subjIDstr,"\nFactors: ",factorsStr,"\n\n")
  }
  df_empty = df
  df_empty$subjID = df_empty[[subjIDstr]]
  # Check for empty cells
  df_empty=df_empty |>  mutate(cellInData = TRUE) |>
    group_by(subjID) |>
    complete(!!!syms(factorsStr)) |>
    mutate(has_empty = any(is.na(cellInData))) |> ungroup()
  nEmptyCells=sum(is.na(df_empty$cellInData))
  # print(nEmptyCells)
  # check if   cellInData is NA in  any row
  if (nEmptyCells>0) {
    warning("Subjects with empty cells detected!\n",immediate. = T,call. =F)
    print(knitr::kable(df_empty |> filter(has_empty) |> distinct(subjID)))
    cat("\nEmpty cells:\n")
    print(knitr::kable(df_empty |> filter(is.na(cellInData)) |> select(all_of(c("subjID",factorsStr)))|> arrange(subjID)))
    # Remove subjects with empty cells
    cat("\nRemoving subjects with empty cells\n")
    df_nonEmpty= df_empty |> filter(!has_empty) |> select(-subjID,-cellInData,-has_empty)
  } else {
    cat("\nNo empty cells detected.\n")
    df_nonEmpty=df
  }

  # Check cell counts, warning if a cell contains more than 1 observation
  cellCounts= df_nonEmpty |>  group_by(across(all_of(c(subjIDstr,factorsStr)))) |>
    count() |>  ungroup()
  maxObsPerCell=max(cellCounts$n)
  if (maxObsPerCell>1) {
    warning("Some cells contain more than 1 observation. Data frame cannot be used in rmANOVA.",immediate. = T,call. =F)
    print(knitr::kable(cellCounts |> filter(n>1)))
  }
  return(list(nEmptyCells=nEmptyCells,df_nonEmpty=df_nonEmpty,maxObsPerCell=maxObsPerCell))
}

