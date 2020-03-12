# Runs a single test (for one configuration) and writes the raw test results + a test report
# Returns a data.table with one row and the columns:
# - csv.file.name (raw results as CSV file)
# - Excel.file.name (raw results as Excel file)
# - report.file.name (generated HTML report with the results)
#
# TODO Rename (use a better function name)
check.test.config.compliance <- function(test.config,
                                              output.folder = "results",
                                              write.raw.results.as.Excel.file = TRUE,
                                              wait.secs.after.start.script = 15) {

  # initialize test run -------------------------------------------------------------------------------------------

  con.args.list  <- key.value.string.as.list(test.config$con.args)

  # attach driver library (if specified)
  if (!is.na(test.config$DBI.driver.pkg.name) & nchar(test.config$DBI.driver.pkg.name) > 0)
    library(test.config$DBI.driver.pkg.name, character.only = TRUE)

  # create driver instance
  # See https://stackoverflow.com/questions/48722602/how-to-call-a-function-using-the-package-and-function-name-in-a-string-with
  DBI.driver <- eval(parse(text = test.config$DBI.driver.constructor))



  # start database via script (if configured)
  if (!is.na(test.config$start.script)) {

    system2(file.path("scripts", test.config$start.script), wait = TRUE)

    # give docker time to start the container (otherwise we will get timeouts).
    # The waiting period could also be implemented inside of the scripts to consider individual timings...
    Sys.sleep(wait.secs.after.start.script)
  }

  # stop database via script (if configured)
  if (!is.na(test.config$stop.script))
    on.exit(system2(file.path("scripts", test.config$stop.script), wait = TRUE))



  # run single test -------------------------------------------------------------------------------------------------

  results.raw <- run.single.compliance.test(DBI.driver, test.config, con.args.list)




  # collect and summarize results -----------------------------------------------------------------------------------

  results               <- new.env()

  results$res.raw       <- results.raw
  results$test.case.groups.pivot.base <- counts.per.test.case.group.as.pivot.base(results$res.raw, incl.totals = TRUE)
  results$per.group.assert.result <- summarize.per.group.assert.count.based(results.raw)
  results$total.assert.summary <- summarize.all.assert.count.based(results.raw)
  results$total.test.case.summary <- summarize.all.testcase.count.based(results.raw)
  results$per.group.test.case.summary <- summarize.per.group.testcase.count.based(results.raw)



  # create output ---------------------------------------------------------------------------------------------------

  # Raw results as Excel file
  if (write.raw.results.as.Excel.file) {
    Excel.file.name   <- make.raw.result.Excel.file.name(results.raw)
    sheets.data       <- list(Summary = results$per.group.test.case.summary, Details = results$res.raw)
    save.raw.results.as.xlsx(sheets.data, Excel.file.name, output.folder)
  }



  # Raw result as CSV file (for comparitive reports comparing different results)
  csv.file.name           <- make.raw.result.CSV.file.name(results.raw)
  csv.file.name.with.path <- file.path(output.folder, csv.file.name)
  data.table::fwrite(results.raw, csv.file.name.with.path, sep = ";")



  # HTML result report
  report.file.name   <- make.single.test.HTML.report.file.name(results.raw)
  res.file <- create.report(results,
                            "report_templates/single_test_config_result_report.Rmd",
                            report.file.name,
                            output.folder = output.folder)



  res <- data.table(csv.file.name    = csv.file.name,
                    Excel.file.name  = Excel.file.name,
                    report.file.name = report.file.name)

  return(res)

}
