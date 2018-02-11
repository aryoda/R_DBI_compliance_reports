# mainly to derive the final result per test case (= per row in the raw result)
enrich.raw.result <- function(result, DBI.driver, DB.info) {



  # Primary key -----------------------------------------------------------------------------------------------

  result[, ID                     := 1:NROW(result)]
  result[, date                   := Sys.Date()]    # date of testing (uses the current time zone)



  # better test case names ------------------------------------------------------------------------------------------

  result[, test.group             := gsub("DBItest: ", "", context, fixed = TRUE)]
  result[, test.name              := stri_replace_first_fixed(test, paste0(context, ": "), "", fixed = TRUE)]



  # DBItest package version -------------------------------------------------------------------------------------

  DBItest.pkg.version <- paste(packageVersion("DBItest"), sep = ".")

  result[, DBItest.pkg.version := DBItest.pkg.version]



  # used database ---------------------------------------------------------------------------

  result[, DB.name                := DB.info$dbms.name]
  result[, DB.version             := DB.info$db.version]



  # driver package ---------------------------------------------------------------------------------

  DBI.driver.pkg         <- attr(class(DBI.driver), "package")   # https://stackoverflow.com/q/48486771/4468078
  DBI.driver.pkg.version <- paste(packageVersion(DBI.driver.pkg), sep = ".")

  result[, DBI.driver.pkg         := DBI.driver.pkg]
  result[, DBI.driver.pkg.version := DBI.driver.pkg.version]



  # testing client infrastructure  ----------------------------------------------------------------------------------

  client.info <- sessionInfo()

  result[, client.OS.name         := client.info$running]     # Sys.info()["sysname"]
  result[, client.OS.platform     := client.info$platform]    # Sys.info()["release"]
  result[, client.OS.version      := Sys.info()["release"]]

  result[, client.R.version       := client.info$R.version$version.string]



  # test case status ------------------------------------------------------------------------------------------------

  result[, TC.result := NA_character_]

  result[is.na(TC.result) & skipped == TRUE,               TC.result := "Skipped"]
  result[is.na(TC.result) & (failed  > 0 | error == TRUE), TC.result := "Failed"]
  result[is.na(TC.result) & (failed == 0),                 TC.result := "Passed"]
  result[is.na(TC.result),                                 TC.result := "Unknown"] # should never happen
  # Warnings are ignored (and should never occur since DBItest handles every warning
  # as failed testthat expectation in the function "wrap_all_statements_with_expect_no_warning()"



  # success.rate per test case---------------------------------------------------------------------------------------

  result[nb > 0       ,    TC.success.rate := round((1 - (failed / nb)) * 100, 1)]
  result[nb == 0      ,    TC.success.rate := 0]  # treat test cases without executed assertions (expectations) as no success
  result[error == TRUE,    TC.success.rate := 0]  # treat all errors as total failure
  result[error == TRUE,    TC.success.rate := 0]  # treat all errors as total failure

  # Background on skip*() in testthat (see the help):
  #   "skip* functions are intended for use within test_that() blocks.
  #   All expectations following the skip* statement within the same test_that block will be skipped.
  #   Test summaries that report skip counts are reporting how many test_that blocks triggered a skip* statement,
  #   not how many expectations were skipped." !!!
  #
  # -> Therefore no success rate is shown for skipped test cases
  #    even though some assertions (expectations may have been checked)!
  result[skipped == TRUE, TC.success.rate := NA]


  # Remove unneccessary columns -------------------------------------------------------------------------------------

  result[, file                   := NULL]  # removes the column that is always empty
  result[, context                := NULL]  # nicer in "test.group" now
  result[, test                   := NULL]  # nicer in "test.name" now



  # Rename columns --------------------------------------------------------------------------------------------------

  setnames(result, "test.name", "test.case.name")



  # Re-order the columns --------------------------------------------------------------------------------------------


  # important columns first, header columns with static content at the end
  setcolorder(result, c("ID", "date", "test.group", "test.case.name",
                              "TC.result", "TC.success.rate",
                              "nb", "failed", "skipped", "error", "warning",
                              "user", "system", "real",
                              "DB.name", "DB.version",
                              "DBI.driver.pkg", "DBI.driver.pkg.version",
                              "DBItest.pkg.version",
                              "client.R.version",
                              "client.OS.name", "client.OS.platform", "client.OS.version" ))



  # Good bye --------------------------------------------------------------------------------------------------------

  return(result)  # support function chaining
}
