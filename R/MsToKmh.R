#' Convert meters per second to kilometers per hour
#' 
#' @param x Speed in m/s
#' @return Speed in km/h
#' @export
MsToKmh <- function(x) {
  return(3.6 * x)
}