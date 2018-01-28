#' Run the test set for one single database connection
#'
#' @param DBI.driver Instance of a DBI driver
#' @param con.args   List with connection settings as named elements (driver specific names)
#' @param skip       Vector of DBItest test names to ignore (skip) as character vector. Used via %in% against test names.
#'
#' @return           The test results as data.table
#'
#' @examples
#' \dontrun{
#'   run_test_set( odbc::odbc(), list(dsn = "mysql_test_database"))
#' }
#'
run_test_set <- function(DBI.driver, con.args, skip = NULL) {

  DBItest::make_context(DBI.driver, connect_args = con.args)



  # extract database engine information
  ctx <- DBItest::get_default_context()
  con <- DBItest:::connect(ctx)
  DB.info <- odbc::dbGetInfo(con)
  odbc::dbDisconnect(con)


  # extract driver package name and version
  DBI.driver.pkg         <- attr(class(DBI.driver), "package")   # https://stackoverflow.com/q/48486771/4468078
  DBI.driver.pkg.version <- paste(packageVersion(DBI.driver.pkg), sep = ".")



  # Info about the client infrastructure the test is running on
  client.info <- sessionInfo()



  # Collect testthat results in a list
  # The result column are not documented very well, so look into the source code here:
  # https://github.com/r-lib/testthat/blob/master/R/reporter-list.R
  # E. g.
  # nb = number of tests (1 test = 1 expectation)
  testthat::set_reporter(ListReporter$new())



  # "test_all" can currently not be used due to bug in odbc/nano that blocks the execution if transactions are used:
  # https://github.com/r-dbi/odbc/issues/138
  # DBItest::test_all(skip = c(".*package_name.*"))

  # Work-around: Execute working tests manually (functions are from DBItest)
  #   Alternative: add blocking tests via the "skip" parameter
  test_getting_started()
  test_driver()
  test_connection()
  test_result()
  test_sql()
  test_meta()
  # test_transaction()  # hangs
  test_compliance()



  # get test results from testthat reporter
  rep <- get_reporter()
  test.results <- as.data.frame(rep$get_results())

  # browser()


  # Derive better test case names and enrich results with the used testing infrastructure
  setDT(test.results)
  test.results[, test.group             := gsub("DBItest: ", "", context, fixed = TRUE)]
  test.results[, test.name              := stri_replace_first_fixed(test, paste0(context, ": "), "", fixed = TRUE)]
  test.results[, ID                     := 1:NROW(test.results)]
  test.results[, DB.name                := DB.info$dbms.name]
  test.results[, DB.version             := DB.info$db.version]
  test.results[, DBI.driver.pkg         := DBI.driver.pkg]
  test.results[, DBI.driver.pkg.version := DBI.driver.pkg.version]
  test.results[, client.OS.name         := client.info$running]     # Sys.info()["sysname"]
  test.results[, client.OS.platform     := client.info$platform]    # Sys.info()["release"]
  test.results[, client.OS.version      := Sys.info()["release"]]
  test.results[, date                   := Sys.Date()]    # date of testing (uses the current time zone)

  # Remove unneccessary columns
  test.results[, file                   := NULL]  # removes the column that is always empty
  test.results[, context                := NULL]  # nicer in "test.group" now
  test.results[, test                   := NULL]  # nicer in "test.name" now



  # Reorder the columns (important ones first, header columns with static content at the end)
  setcolorder(test.results, c("ID", "date", "test.group", "test.name",
                              "nb", "failed", "skipped", "error", "warning",
                              "user", "system", "real",
                              "DB.name", "DB.version",
                              "DBI.driver.pkg", "DBI.driver.pkg.version",
                              "client.OS.name", "client.OS.platform", "client.OS.version" ))



  # str(test.results)



  return(test.results)

}
