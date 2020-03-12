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

# For list of dynamically loaded DBI driver packages see the "test_configs.xlsx" file!



source("R/get_test_configurations.R")
source("R/run_single_compliance_test.R")
source("R/enrich_raw_result.R")
source("R/normalize_DBMS_names.R")
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
source("R/collect_test_results_from_files.R")



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




all.result.files <- c()

for (i in 1:NROW(active.test.configs)) {

  test.config <- active.test.configs[i, ]

  result.files <- check.test.config.compliance(test.config, output.folder)

  all.result.files <- rbind(all.result.files, result.files)

  # Append to an index file containing the result file names for all tested configurations
  data.table::fwrite(result.files, result.file.list, append = TRUE, sep = ";")

}

# The variable "raw.result.files" does now contain one row per tested configuration with the columns:
# - csv.file.name (raw results as CSV file)
# - Excel.file.name (raw results as Excel file)
# - report.file.name (generated HTML report with the results)



# Generate report to compare archived results ----------------------------------------------------------------------------------

# The following code uses already existing test results (from archived file)
# together with the just created test results
# to generate a report that compares archived test results
# without permanent retesting of old results.
#
# Note: If no archived test run files are checked in into the Git repo this is due to legal restrictions :-(
#
# To add test results to the report edit the index file and add your data file names:
index.file.name <- "results/private_archive/list_of_archived_result_files.txt"   # modify with your sub folder and file name

if (file.exists(index.file.name)) {

  print("Info: Found archived data files...")

  list.of.archived.result.files <- read.csv(index.file.name, header = FALSE, stringsAsFactors = FALSE)
  list.of.archived.result.files <- list.of.archived.result.files$V1     # $V1 constains the file names

} else {

  print("Info: No archived test data files found...")
  list.of.archived.result.files = NULL

}

data  <- collect.test.results.from.files(output.folder
                                         , all.result.files$csv.file.name   # contains the file names with the results of the current test runs
                                         , list.of.archived.result.files)   # contains file names with the results of the archived test runs

results <- new.env()  # environment with all data and meta data to generate a report

results$res.raw <- data
results$archive.subfolder.name <- "private_archive"   # modify with your sub folder name
results$test.case.groups.pivot.base <- counts.per.test.case.group.as.pivot.base(data, incl.totals = TRUE)

# Generate HTML result report
# TODO Hyperlink to single test run result reports do not work (missing sub folder + wrong report names)
report.file.name   <- "Comparative_report.html"
res.file <- create.report(results,
                          "report_templates/comparative_result_report.Rmd",
                          report.file.name,
                          output.folder = output.folder)

# Open the generated report
browseURL(file.path(output.folder, report.file.name))



