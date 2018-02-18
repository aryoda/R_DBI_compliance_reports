# ---------------------------------------------------------------------------------------------------------------
# THIS IS THE MAIN ENTRY POINT TO EXECUTE THE TEST RUNS
# ---------------------------------------------------------------------------------------------------------------


library(tools)        # for file name handling...
library(DBI)
library(odbc)
library(DBItest)
library(RSQLite)      # devtools::install_github("rstats-db/RSQLite")
library(testthat)
library(data.table)
library(stringi)
library(openxlsx)
library(kableExtra)   # install.packages("kableExtra")
# Not used currently (and not available for every current R version!)
# library(formattable)  # install.packages("formattable")

# To run the tests against the most-recent development versions (master) install from github:
# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")
# ...


source("R/get_test_configurations.R")
source("R/run_single_compliance_test.R")
source("R/enrich_raw_result.R")
source("R/summarize_single_test_results.R")
source("R/make_results_file_name.R")
source("R/save_raw_results_as_xlsx.R")
source("R/derive_pct_HTML_color.R")
source("R/derive_strings_HTML_color.R")
source("R/add_test_config_row.R")
source("R/key_value_string_as_list.R")
source("R/check_test_config_compliance.R")
source("R/create_report.R")
source("R/summarize_comparative_results.R")
source("R/build_connect_string.R")
source("R/collect_comparative_test_results.R")



# Init test configurations ----------------------------------------------------------------------------------------

test.configs <- get.test.configurations()



# inject personal connection strings without exposing them to the internet (github)
local.conf.file <- "localmachine.config.R"
if (file.exists("local.conf.file"))
  source("localmachine.config.R")



output.folder <- "results"



# Create an empty result list file (or overwrite the existing one with an empty file).
# This file will contain one CSV file name per test run.
# Each CSV file name "points" to the raw result file...
# This list file is updated after each test run to survive run-time errors that stop R.
result.file.list <- file.path(output.folder, "result_files_list.csv")
res              <- file.create(result.file.list)



# Run tests -------------------------------------------------------------------------------------------------------

active.test.configs <- test.configs[execute.test.flag == TRUE, ]



raw.result.files <- c()

for (i in 1:NROW(active.test.configs)) {

  test.config <- active.test.configs[i, ]

  result.files <- check.test.config.compliance(test.config, output.folder)

  raw.result.files <- rbind(raw.result.files, result.files)

  data.table::fwrite(result.files, result.file.list, append = TRUE, sep = ";")

}



# Generate comparative reports ------------------------------------------------------------------------------------

# (Much :-) TODO

data  <- collect.comparative.test.results(output.folder,
                                          raw.result.files$csv.file.name)
                                          # , "2018-02-13_odbc_MySQL_5.7.21_Ubuntu.14.04.5.LTS.csv") # test data!

results <- new.env()

results$res.raw                     <- data
results$test.case.groups.pivot.base <- counts.per.test.case.group.as.pivot.base(data, incl.totals = TRUE)



# HTML result report
report.file.name   <- "Comparative_report.html"
res.file <- create.report(results,
                          "report_templates/comparative_result_report.Rmd",
                          report.file.name,
                          output.folder = output.folder)

browseURL(file.path(output.folder, report.file.name))

