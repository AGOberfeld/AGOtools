#' Convert km/h to m/s
#' @param x Speed in km/h
#' @return Speed in m/s
#' @export
KmhToMs <- function(x) {
  return(x / 3.6)
}

#' Convert meters per second to kilometers per hour
#' 
#' @param x Speed in m/s
#' @return Speed in km/h
#' @export
MsToKmh <- function(x) {
  return(3.6 * x)
}