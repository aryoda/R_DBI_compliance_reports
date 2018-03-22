#' Constructs a file name from a DBItest result
#'
#' Optionally add an output filder to the file name
#'
#' @param results         result data.frame from a testthat ListReporter
#' @param file.ext        the file extension of the file (without the leading dot)
#' @param date.as.prefix  logical to indicate if the current date shall be added as file name prefix
#'
#' @return                The file name as character
#'
make.results.file.name <- function(results.raw, file.ext, date.as.prefix = TRUE) {

  # date.prefix <- format(Sys.time(), format = "%Y-%m-%d")
  date.prefix <- format(results.raw$date[1], format = "%Y-%m-%d")


  file.name   <- paste0(results.raw$DBI.driver.pkg[1], "_",
                        results.raw$DB.name[1], "_",
                        results.raw$DB.version[1], "_",
                        results.raw$client.OS.name[1], ".",
                        file.ext)

  file.name   <- make.names(file.name)  # replace invalid characters

  if (date.as.prefix)
    file.name <- paste0(date.prefix, "_", file.name)

  return(file.name)

}



# The file name for an Excel file containing the results for (human) exploration
make.raw.result.Excel.file.name <- function(results.raw) {

  file.name   <- make.results.file.name(results.raw, "xlsx", TRUE)

  return(file.name)

}



# The file name for an Excel file containing the results for (human) exploration
make.raw.result.CSV.file.name <- function(results.raw) {

  file.name   <- make.results.file.name(results.raw, "csv", TRUE)

  return(file.name)

}



# The file name of the HTML results report for one single test configuration
make.single.test.HTML.report.file.name <- function(results.raw) {

  file.name   <- make.results.file.name(results.raw, "html", TRUE)

  return(file.name)

}
