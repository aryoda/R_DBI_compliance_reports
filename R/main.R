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
library(formattable)  # install.packages("formattable")

# To run the tests against the most-recent development versions (master) install from github:
# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")
# ...


source("R/get_test_configurations.R")
source("R/run_test_set.R")
source("R/enrich_raw_result.R")
source("R/summarize_test_result.R")
source("R/make_results_file_name.R")
source("R/save_raw_results_as_xlsx.R")
source("R/create_results_report.R")
source("R/derive_pct_HTML_color.R")
source("R/derive_strings_HTML_color.R")
source("R/add_test_config_row.R")
source("R/key_value_string_as_list.R")
source("R/prepare_run_summarize_single_test.R")



# Init test configurations ----------------------------------------------------------------------------------------

test.configs <- get.test.configurations()



# inject personal connection strings without exposing them to the internet (github)
local.conf.file <- "localmachine.config.R"
if (file.exists("local.conf.file"))
  source("localmachine.config.R")



# Run tests -------------------------------------------------------------------------------------------------------

active.test.configs <- test.configs[ execute.test.flag == TRUE, ]


raw.result.files <- c()

for (i in 1:NROW(active.test.configs)) {

  test.config <- active.test.configs[i, ]

  raw.result.csv.file <- prepare.run.summarize.single.test(test.config)

  raw.result.files <- c(raw.result.files, raw.result.csv.file)

}



# Generate comparative reports ------------------------------------------------------------------------------------

# (Much :-) TODO


