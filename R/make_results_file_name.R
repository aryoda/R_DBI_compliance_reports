#' Constructs a file name from a DBItest result
#'
#' @param results         result data.frame from a testthat ListReporter
#' @param file.ext        the file extension of the file (without the leading dot)
#' @param date.as.prefix  logical to indicate if the current date shall be added as file name prefix
#' @param output.folder   the output folder (without a trailing path separator)
#'
#' @return                The file name as character
#'
make.results.file.name <- function(results, file.ext, date.as.prefix = TRUE, output.folder = "results") {

  date.prefix <- format(Sys.time(), format = "%Y-%m-%d")


  file.name   <- paste0(results$DBI.driver.pkg[1], "_",
                        results$DB.name[1], "_",
                        results$DB.version[1], "_",
                        results$client.OS.name[1], ".",
                        file.ext)

  file.name   <- make.names(file.name)  # replace invalid characters

  if (date.as.prefix)
    file.name <- paste0(date.prefix, "_", file.name)

  file.name   <- file.path(output.folder, file.name)

  return(file.name)

}
