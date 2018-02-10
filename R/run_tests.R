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

# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")



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



# Init test configurations ----------------------------------------------------------------------------------------

source("R/test_configs.R")



# inject personal connection strings without exposing them to the internet (github)
local.conf.file <- "localmachine.config.R"
if (file.exists("local.conf.file"))
  source("localmachine.config.R")



# con.args <- mysql_con_args
# con.args <- sqlite_con_args

# con.args <- postgreSQL_docker    # works
# con.args <- mysql_on_docker      # works
####### con.args <- sqlite3_in_memory    # works (requires RSQLite)
# con.args <- sqlite3_odbc_in_mem  # works (using odbc)


# DBI.driver <- odbc::odbc()      # postgres and mysql
###### DBI.driver <- RSQLite::SQLite() # sqlite3



# initialize test run -------------------------------------------------------------------------------------------

# !!! pick one config row as active test config
test.config <- test.configs[1,]

con.args  <- key.value.string.as.list(test.config$con.args)

if (!is.na(test.config$DBI.driver.pkg.name) & nchar(test.config$DBI.driver.pkg.name) > 0)
  library(test.config$DBI.driver.pkg.name, character.only = TRUE)

DBI.driver <- eval(parse(text = test.config$DBI.driver.constructor))  # see https://stackoverflow.com/questions/48722602/how-to-call-a-function-using-the-package-and-function-name-in-a-string-with




# run single test -------------------------------------------------------------------------------------------------

results.raw <- run_test_set(DBI.driver, con.args)



# prepare results -------------------------------------------------------------------------------------------------

results               <- new.env()

results$res.raw       <- results.raw
results$test.case.groups.pivot.base <- counts.per.test.case.group.as.pivot.base(results$res.raw, incl.totals = TRUE)
results$per.group.assert.result <- summarize.per.group.assert.count.based(results.raw)
results$total.assert.summary <- summarize.all.assert.count.based(results.raw)
results$total.test.case.summary <- summarize.all.testcase.count.based(results.raw)
results$per.group.test.case.summary <- summarize.per.group.testcase.count.based(results.raw)



# create output ---------------------------------------------------------------------------------------------------

file.name   <- make.results.file.name(results.raw, "xlsx", TRUE, "results")
sheets.data <- list(Summary = results$per.group.test.case.summary, Details = results$res.raw)
save.raw.results.as.xlsx(sheets.data, file.name)


create_results_report(results, "R/result_report.Rmd", output.folder = "results")



# Test plots ------------------------------------------------------------------------------------------------------


