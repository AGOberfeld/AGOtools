#' safe_quickpsy
#'
#' workaround to prevent quickpsy from stopping if hessian matrix is not solvable.
#' for parameter information see `?quickpsy`.
#'
#' @param part_id variable that encodes the participant numbers.
#' @param data data frame.
#' @param x explanatory variable.
#' @param k response variable.
#' @param n number of trials.
#' @param grouping grouping varibale as c("var1","var",...).
#'
#' @importFrom rlang enexpr as_string is_error error_cnd
#' @importFrom stringr str_c str_flatten
#' @importFrom dplyr filter
#' @importFrom quickpsy quickpsy
#'
#' @return a list containing quickpsy objects for each participant.
#' @export
#' @examples
#' safe_quickpsy(data = streetcrossing,
#'               part_id = vp_code,
#'               x = track_TTC,
#'               k = nCross,
#'               n = nTrials,
#'               grouping = c("vp_code","modality","v0","a","label","gain"))
#'

safe_quickpsy <- function(part_id,data,x,k,n,grouping){

  #browser()

  part_id_str <- rlang::as_string(rlang::enexpr(part_id))
  x_str <- rlang::as_string(rlang::enexpr(x))
  k_str <- rlang::as_string(rlang::enexpr(k))
  n_str <- rlang::as_string(rlang::enexpr(n))
  grouping <- as.character(c(part_id_str,grouping))

  # extract participant ids:
  vp_codes <- data[[part_id_str]] %>%
    unique()

  qp_list <- list()
  condition_list <- data %>%
    group_split(!!!syms(grouping))

  # loop across all participants:
  for (i in seq_along(vp_codes)){
    data <- data %>%
      filter((!!sym(part_id_str)) == vp_codes[i])

    qp_list[[i]] <- tryCatch(quickpsy(d = data,
                   x = !!sym(x_str),
                   k = !!sym(k_str),
                   n = !!sym(n_str),
                   grouping = c(!!!syms(grouping)),
                   fun=cum_normal_fun,
                   guess=0,
                   lapses=0,
                   bootstrap = 'none'),

                   warning = function(w){print(w)},

                   error = function(e){e},

                   finally = "finished")

    names(qp_list)[i] <- vp_codes[i]
  }

  qp_list_clean <- qp_list[!sapply(qp_list, rlang::is_error)]

  error_names <- names(qp_list[sapply(qp_list, rlang::is_error)])

  if(length(error_names) > 0){
    warning(str_c("Error occurred in: ",
                  str_flatten(error_names,collapse = ", "),
                  "\n"))
  }

  return(qp_list_clean)

}

