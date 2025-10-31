################################################################################
################## FUNCTIONS FOR DOING CPIA COMPUTATIONS #######################
################################################################################

#' Convert CTF Static Score to CPIA Scale
#'
#' This function converts a CTF score to the CPIA (Country Policy and Institutional Assessment)
#' scale using a simple linear transformation.
#'
#' The transformation is defined as:
#' \deqn{CPIA = 5 * mean(CTF, na.rm = TRUE) + 1}
#'
#' Missing values in the input vector are ignored during the mean calculation.
#'
#' @param x A numeric vector of CTF static scores.
#'
#' @return A numeric value representing the corresponding CPIA score.
#'
#' @examples
#' # Example usage
#' convert_ctf_to_cpia(c(0.5, 0.6, 0.4))
#' convert_ctf_to_cpia(c(NA, 0.8, 0.7))
#'
#' @export
#'
convert_ctf_to_cpia <- function(x){

  y <- 5 * mean(x, na.rm = TRUE) + 1

  return(y)

}
