#' Assign an HTML color code for each string in a vector
#'
#' This function is mainly used to assign an HTML color to a test case result but
#' can be used for every other string values too.
#'
#' @param strings        Character vector with the test case results
#' @param string.colors  Character vector with named color codes
#'                       (the names must match with the values in the \code{strings} argument
#' @param others.color   The color to be used if no matching color was found in \code{string.colors}.
#'
#' @return               A character vector of the same length as the \code{strings} argument
#'                       containing the HTML color codes
#' @export
#'
#' @examples
#' derive.strings.HTML.color(c("hello", "new", "world"), string.colors = c("hello" = "green", "world" = "blue"), "yellow")
#' # Result: "green" "yellow"   "blue"
derive.strings.HTML.color <- function(strings,
                                               string.colors = c(Failed = "red",
                                                                 Unknown = "#E18700",
                                                                 Passed = "#2dc937",
                                                                 Skipped = "BLUE"),
                                               others.color = "yellow") {

  # use upper case result names for more tolerant matching
  names(string.colors) <- stri_trans_toupper(names(string.colors))

  res.colors <- string.colors[stri_trans_toupper(strings)]

  res.colors[is.na(res.colors)] <- others.color



  return(res.colors)

}
