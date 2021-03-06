#' Loads the raw results of single tests into one data.table for further processing
#'
#' You can not only load the results of the current test runs but also mix in
#' results from other test runs (e. g. on different machines with different operating systems
#' or historical results) for a holistic comparative result or as benchmark.
#'
#' @param output.folder             where to find the data files
#' @param result.file.list          Character vector with the file names containing single test results
#'                                  from the current (last) run of different test configurations
#' @param external.result.file.list Optional: Character vector with the file names containing single test results
#'                                  created on another machine (or same machine but in the past).
#' @param normalize.legacy.names    Normalize names (like DBMS names) that have not been normalized
#'                                  when the results were saved
#'
#' @return                          all raw test results in one single data.table
#' @export
#'
#' @examples
collect.test.results.from.files <- function(output.folder, result.file.list, external.result.file.list = NULL, normalize.legacy.names = TRUE) {

  stopifnot("character" == class(result.file.list))
  stopifnot(is.null(external.result.file.list) | "character" == class(external.result.file.list))
  stopifnot("character" == class(output.folder))



  file.list <- c(result.file.list, external.result.file.list)

  stopifnot(anyDuplicated(file.list) == 0)    # duplicated file names are not allowed (would cause wrong results)



  data <- list()

  for(i in seq_along(file.list)) {
    test.config.data = fread(file.path(output.folder, file.list[i]),
                             sep = ";",
                             stringsAsFactors = FALSE,
                             colClasses = c(OS.driver.name = "character"),   # default class would be int (causing NAs for emtpy values)
                             na.strings = NULL)                              # no NAs in character columns
    test.config.data[, test.config.ID := i]    # add a unique ID to ease data aggregation later
    data[[i]] = test.config.data
  }



  res <- rbindlist(data, use.names = TRUE, fill = TRUE)   # also fills missing columns added later to the testthat ListReporter



  # Fix legacy non-normalized names
  if (normalize.legacy.names) {
    res[, DB.name         := normalize.DBMS.names(DB.name, DB.version)]
  }



  return(res)

}
