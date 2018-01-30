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

# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")



source("R/run_test_set.R")
source("R/summarize_test_result.R")
source("R/make_results_file_name.R")
source("R/save_raw_results_as_xlsx.R")
source("R/create_results_report.R")
source("R/derive_pct_HTML_color.R")



# inject connection strings without exposing them to the internet
source("localmachine.config.R")

# con.args <- mysql_con_args
# con.args <- sqlite_con_args

# con.args <- postgreSQL_docker    # works
# con.args <- mysql_on_docker      # works
# con.args <- sqlite3_in_memory    # works (requires RSQLite)
con.args <- sqlite3_odbc_in_mem  # works (using odbc)


DBI.driver <- odbc::odbc()      # postgres and mysql
# DBI.driver <- RSQLite::SQLite() # sqlite3



results.raw <- run_test_set(DBI.driver, con.args)



results               <- new.env()
results$raw           <- results.raw
results$agg.per.group <- summarize.test.per.group(results.raw)
results$total.summary <- summarize.all.test(results.raw)



file.name   <- make.results.file.name(results.raw, "xlsx", TRUE, "results")
sheets.data <- list(Summary = results$agg.per.group, Details = results$raw)
save.raw.results.as.xlsx(sheets.data, file.name)


create_results_report(results, "R/result_report.Rmd", output.folder = "results")

