# mainly to derive the final result per test case (= per row in the raw result)
enrich.raw.result <- function(result, DB.info) {



  # Primary key -----------------------------------------------------------------------------------------------

  result[, ID                     := 1:NROW(result)]
  result[, date                   := Sys.Date()]    # date of testing (uses the current time zone)



  # better test case names ------------------------------------------------------------------------------------------

  result[, test.group             := gsub("DBItest: ", "", context, fixed = TRUE)]
  result[, test.name              := stri_replace_first_fixed(test, paste0(context, ": "), "", fixed = TRUE)]



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

  result[, test.case.result := NA_character_]

  result[is.na(test.case.result) & skipped == TRUE,               test.case.result := "Skipped"]
  result[is.na(test.case.result) & (failed  > 0 | error == TRUE), test.case.result := "Failed"]
  result[is.na(test.case.result) & (failed == 0),                 test.case.result := "Passed"]
  result[is.na(test.case.result),                                 test.case.result := "Unknown"]
  # Warnings are ignored (and should never occur since DBItest handles every warning
  # as failed testthat expectation in the function "wrap_all_statements_with_expect_no_warning()"



  # success.rate per test case---------------------------------------------------------------------------------------

  result[nb > 0       ,    test.case.success.rate := round((1 - ((skipped + failed) / nb)) * 100, 1)]
  result[nb == 0      ,    test.case.success.rate := 0]  # treat test cases without executed assertions (expectations) as no success
  result[error == TRUE,    test.case.success.rate := 0]  # treat all errors as total failure



  # Remove unneccessary columns -------------------------------------------------------------------------------------

  result[, file                   := NULL]  # removes the column that is always empty
  result[, context                := NULL]  # nicer in "test.group" now
  result[, test                   := NULL]  # nicer in "test.name" now



  # Re-order the columns --------------------------------------------------------------------------------------------


  # important columns first, header columns with static content at the end
  setcolorder(result, c("ID", "date", "test.group", "test.name",
                              "test.case.result", "test.case.success.rate",
                              "nb", "failed", "skipped", "error", "warning",
                              "user", "system", "real",
                              "DB.name", "DB.version",
                              "DBI.driver.pkg", "DBI.driver.pkg.version",
                              "client.R.version",
                              "client.OS.name", "client.OS.platform", "client.OS.version" ))



  # Good bye --------------------------------------------------------------------------------------------------------

  return(result)  # support function chaining
}
