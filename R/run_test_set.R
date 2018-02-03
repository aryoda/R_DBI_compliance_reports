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
  DB.info <- dbGetInfo(con)              # is working when using odbc package but:
  # Warning message: RSQLite::dbGetInfo() is deprecated: please use individual metadata functions instead
  dbDisconnect(con)   # odbc::



  # some drivers require calling specific methods
  if (length(DB.info) == 0) {
    if (class(DBI.driver) == "SQLiteDriver") {
      DB.info$dbms.name  <- "SQLite"
      DB.info$db.version <- RSQLite::rsqliteVersion()["library"]
    }
  }

  # Translation of SQL Server internal versions into official versions:
  # https://support.microsoft.com/en-us/help/321185/how-to-determine-the-version--edition-and-update-level-of-sql-server-a
  # 11.x = SQL Server 2012
  # 12.x = SQL Server 2014
  # 13.x = SQL Server 2016
  # 14.x = SQL Server 2017






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
  setDT(test.results)



  enrich.raw.result(test.results, DB.info)



  # str(test.results)



  return(test.results)

}
