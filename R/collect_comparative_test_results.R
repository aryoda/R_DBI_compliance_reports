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
#'
#' @return
#' @export
#'
#' @examples
collect.comparative.test.results <- function(output.folder, result.file.list, external.result.file.list = NULL) {

  stopifnot("character" == class(result.file.list))
  stopifnot(is.null(external.result.file.list) | "character" == class(external.result.file.list))
  stopifnot("character" == class(output.folder))



  file.list <- c(result.file.list, external.result.file.list)

  stopifnot(anyDuplicated(file.list) == 0)



  data <- list()

  for(i in seq_along(file.list)) {
    test.config.data = fread(file.path(output.folder, file.list[i]), sep = ";")
    test.config.data[, test.config.ID := i]    # add a unique ID to ease data aggregation later
    data[[result.file.list[i]]] = test.config.data
  }



  res <- rbindlist(data, use.names = TRUE)



  return(res)

}
