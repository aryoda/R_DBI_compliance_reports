#' Run the test set for one single database connection
#'
#' @param DBI.driver  Instance of a DBI driver
#' @param test.config active test configuration (row from the config file)
#' @param skip        Vector of DBItest test names to ignore (skip) as character vector. Used via %in% against test names.
#' @param con.args.list
#'
#' @return           The test results as data.table
#'
#' @examples
#' \dontrun{
#'   run_test_set( odbc::odbc(), list(dsn = "mysql_test_database"))
#' }
#'
run.single.compliance.test <- function(DBI.driver, test.config, con.args.list, skip = NULL) {

  DBItest::make_context(DBI.driver, connect_args = con.args.list)



  # extract database engine information
  ctx <- DBItest::get_default_context()
  con <- DBItest:::connect(ctx)
  DB.info <- dbGetInfo(con)              # is working when using odbc package but:
  # Warning message: RSQLite::dbGetInfo() is deprecated: please use individual metadata functions instead
  dbDisconnect(con)



  # some drivers require calling specific methods
  if (length(DB.info) == 0) {
    if (class(DBI.driver) == "SQLiteDriver") {
      DB.info$dbms.name  <- "SQLite"
      DB.info$db.version <- RSQLite::rsqliteVersion()["library"]
    }
  }

  # RMariaDB:
  if ("MariaDBDriver" %in% class(DBI.driver)) {
    DB.info$dbms.name  <- "MySQL"
    DB.info$db.version <- DB.info$serverVersion
  }

  # RPostgres:
  if ("PqDriver" %in% class(DBI.driver)) {
    DB.info$dbms.name  <- DB.info$dbname
    DB.info$db.version <- DB.info$server_version
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
  # DBItest::test_all(skip = c("test name sub string"))
  #
  # skip well known transaction test cases that use rollback:
  skip.for.sure = c("with_transaction_error_nested", "with_transaction_failure",
                    "begin_rollback", "begin_write_rollback", "begin_commit_return_value", "begin_rollback_return_value",
                    "begin_rollback", "begin_write_rollback")
  skip.maybe    = c("begin_commit_closed",
                    "begin_commit_invalid",
                    "rollback_without_begin",
                    "begin_begin",
                    "begin_commit",
                    "begin_write_commit",
                    "begin_rollback",
                    "begin_write_rollback")
  skip = c(skip.for.sure, skip.maybe)

  # Work-around: Execute working tests manually (functions are from DBItest)
  #   Alternative: add blocking tests via the "skip" parameter
  test_getting_started()
  test_driver()
  test_connection()
  test_result()
  test_sql()
  test_meta()
  # if (!"odbc" %in% class(DBI.driver))  # postgres with RPostgres throws errors :-(
  #  test_transaction()  # hangs with odbc package, so do the test only for other drivers (https://github.com/r-dbi/odbc/issues/138)
  # test_transaction(skip = skip)  # shouldn't hang if used with odbc package (hopefully on every platform)
  test_compliance()



  # get test results from testthat reporter
  rep <- get_reporter()
  test.results <- as.data.frame(rep$get_results())
  setDT(test.results)


  enrich.raw.result(test.results, test.config, con.args.list, DBI.driver, DB.info)



  # str(test.results)



  return(test.results)

}
