#' Gives a color value for each percentage value according to defined buckets
#'
#' @param pct.values     Numeric vector with the percentage values
#' @param pct.breaks     Numeric vector with the bucket cut points (from 0 to 101 to include 100 %)
#' @param bucket.colors  Vector of color codes as characters (color name or hex color code).
#'                       You must provide one element per bucket (= length of pct.breaks minus one).
#'                       The default values are red, orange and green.
#' @param NA.color       HTML color code for NA values (as character)
#'
#' @return   A vector
#' #cc3232 #db7b2b E18700
#' @examples
#' derive.pct.HTML.color(c(0, 20, 40, 60, 80, 90, 95, 96, 100))
#' derive.pct.HTML.color(c(0.5, 1, 0, NA))
derive.pct.HTML.color <- function(pct.values,
                                  pct.breaks    = c(0, 75, 95, 101),
                                  bucket.colors = c("red", "#E18700", "#2dc937"),
                                  NA.color = "blue") {

   # buckets for the color codes

  buckets <- cut(pct.values, breaks = pct.breaks, right = FALSE, labels = FALSE)

  colors <- bucket.colors[buckets]

  colors[is.na(colors)] <- NA.color

  return(colors)

}
