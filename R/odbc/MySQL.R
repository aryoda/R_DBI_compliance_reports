library(DBI)
library(odbc)
library(DBItest)
library(testthat)
library(data.table)
library(stringi)

# devtools::install_github("r-dbi/DBI")
# devtools::install_github("r-dbi/odbc")
# devtools::install_github("r-dbi/DBItest")



# https://www.connectionstrings.com/
# https://cran.r-project.org/web/packages/DBI/DBI.pdf


# inject connection strings without exposing them to the internet
source("localmachine.config.R")



# DBItest::make_context(odbc::odbc(), connect_args = mysql_con_args)
DBItest::make_context(odbc::odbc(), connect_args = sqlite_con_args)

ctx <- DBItest::get_default_context()
con <- DBItest:::connect(ctx)
DB.info <- odbc::dbGetInfo(con)
odbc::dbDisconnect(con)

# Collect testthat results in a list
testthat::set_reporter(ListReporter$new())



# "test_all" can currently not be used due to bug in odbc/nano that blocks the execution if transactions are used:
# https://github.com/r-dbi/odbc/issues/138
# DBItest::test_all(skip = c(".*package_name.*"))

# Work-around: Execute working tests manually
#   Alternative: add blocking tests via the "skip" parameter
DBItest::test_getting_started()
test_driver()
test_connection()
test_result()
test_sql()
test_meta()
# test_transaction()  # hangs
test_compliance()



# get test results from testthat reporter
rep <- get_reporter()
test.results <- as.data.frame(rep$get_results())



# Derive better test case names
setDT(test.results)
test.results[, test_group := gsub("DBItest: ", "", context, fixed = TRUE)]
test.results[, test_name  := stri_replace_first_fixed(test, paste0(context, ": "), "", fixed = TRUE)]
test.results[, ID         := 1:NROW(test.results)]
test.results[, DB.name    := DB.info$dbms.name]
test.results[, DB.version := DB.info$db.version]
# str(test.results)



# Summarize the test results
test.results[, .(num.of.tests = sum(nb),
                 success.rate = round((1 - ((sum(skipped) + sum(failed)) / sum(nb))) * 100, 1), # unclear: also consider error count?
                 failed = sum(failed),
                 errors = sum(error),
                 warnings = sum(warning),
                 skipped = sum(skipped)),
             by = .(DB.name, DB.version, test_group)]



# Now we have all test results in the data.table "test.results"

# Example;
#
#    DB.name     DB.version      test_group num.of.tests success.rate failed errors warnings skipped
# 1:   MySQL 5.5.54-MariaDB Getting started           11         90.9      1      0        0       0
# 2:   MySQL 5.5.54-MariaDB          Driver          104        100.0      0      0        0       0
# 3:   MySQL 5.5.54-MariaDB      Connection           89        100.0      0      0        0       0
# 4:   MySQL 5.5.54-MariaDB          Result          839         98.3     14      2        0       0
# 5:   MySQL 5.5.54-MariaDB             SQL         1434         98.2     26     13        0       0
# 6:   MySQL 5.5.54-MariaDB        Metadata          186         84.4      4      1        0      25
# 7:   MySQL 5.5.54-MariaDB Full compliance          109        100.0      0      0        0       0

#    DB.name DB.version      test_group num.of.tests success.rate failed errors warnings skipped
# 1:  SQLite   3.7.16.2 Getting started           11         90.9      1      0        0       0
# 2:  SQLite   3.7.16.2          Driver          104        100.0      0      0        0       0
# 3:  SQLite   3.7.16.2      Connection           84         97.6      2      0        0       0
# 4:  SQLite   3.7.16.2          Result          809         90.7     75      3        0       0
# 5:  SQLite   3.7.16.2             SQL         1406         96.9     43     15        0       0
# 6:  SQLite   3.7.16.2        Metadata          186         85.5      2      1        0      25
# 7:  SQLite   3.7.16.2 Full compliance          109        100.0      0      0        0       0


# TODO: NiceRMarkdown report


