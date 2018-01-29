library(DBI)
library(odbc)
library(DBItest)
library(testthat)
library(data.table)
library(stringi)
library(openxlsx)
library(kableExtra) # install.packages("kableExtra")

# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")



source("R/run_test_set.R")
source("R/summarize_test_result.R")



# inject connection strings without exposing them to the internet
source("localmachine.config.R")
# con.args <- mysql_con_args
# con.args <- sqlite_con_args
con.args <- postgres_con_args


DBI.driver <- odbc::odbc()


res <- run_test_set(DBI.driver, con.args)  # last known working was: postgres_con_args

group.res <- summarize.test.per.group(res)
total.res <- summarize.all.test(res)

date.prefix <- format(Sys.time(), format = "%Y-%m-%d")
file.name   <- paste0(res$DBI.driver.pkg[1], "_", res$DB.name[1], ".", res$DB.version[1], "_", res$client.OS.name[1], ".xlsx")
file.name   <- make.names(file.name)
file.name   <- paste0("results/", date.prefix, "_", file.name)

sheet.names <- list(Summary = group.res, Details = res)

wb <- openxlsx::write.xlsx(sheet.names,
                           file.name,
                           asTable     = c(TRUE, TRUE),
                           # sheetName   = c("Summary", "Details"),
                           withFilter  = c(FALSE, TRUE),
                           colWidths   = "auto",
                           firstRow    = TRUE)

# saveWorkbook(wb, file.name, overwrite = TRUE)   # wb could be used to modify the Excel sheets even more...

data           <- new.env()
data$res       <- res
data$group.res <- group.res
data$total.res <- total.res

rmarkdown::render("R/result_report.Rmd", output_format = "all", output_dir = "results/", envir = data)
