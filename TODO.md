# TODO list


## Open

- Create RMarkdown report for summarized and detailled results and plots (comparing all tested databases)
- store historical results to show a time series of test results
- Support consistent comparisson:
  Order the result groups to keep the same order over time in the plots and summary tables
- result details shall show per single test case:
  Passed, Failed, Skipped with green, red, yellow background + personal notes + link to open ticket(s)...
- Refactor code to allow better reuse for different DBI drivers and databases
- Dockerize?
! Improve `DBItest` by opening feature requests:
  Annotate test cases with description, functions under test, link to test code,
  annotate each checked expectation with a good name, add a severity class to each test {fatal, err, warn, info} ...
  Make spec_*() public to be able to see the available test names and test code (without looking into
  the DBItest source code) + being able to compare the number of executed test cases against the number
  of available test case (since the DBItest::test_* functions have a skip parameter that skips tests
  that are not counted as skipped in testthat => let testthat do the skip instead of skip the test within DBItest
  [see run_test() in run.R] to allow testthat a consistent report of all skipped tests)
- add a better reporter for testthat that returns the most granular results
  (e. g. one row per expectation + support for the number of skipped tests instead of a logical flag)
- List known DBI driver packages in the readme (reverse dependency of CRAN may help but it ignores new packages at github...)
- store results as CSV file to be read again for comparing the results of different set-ups
- also check odbc:RODBC bridge driver to show differences in implementations (RODBCDBI::ODBC())
- call test_all + specify the skip param instead of calling every single test case group (for a correct skip summary)
- fix or minimize transaction testing problem (e. g. via skip until the bug is fixed in `odbc`)
- centralize used color scheme (color codes) to support changing it in one place (currently spreaded in the report)
- rename testhat reporter column names in result.raw for consistent names in reports (no more renamings in reports)
- result.raw: logical columns should be converted to Y/N (nicer in reports than true/false)
- define terminology with DBItest team and use it consistent allover the source code and reports
    + test case: A call of `testthat::test_that()`
    + assertion: A call of `testthat::expect*()`
    + test environment (or: platform?): The client-side operating system, R version and package versions
    + test configuration: A combination of a database, DBI driver and connection properties (the DB-Server OS is ignored here!)
    + test run
    + maturity = level of DBI compliance
- Test the package `rsqlserver` that uses `rClr` and the .Net namespace `System.Data.SqlClient`.
  This could be done using a Docker container:
  https://github.com/agstudy/rsqlserver
- Add `RMariaDB` DBI package to the supported test configuration:
  https://github.com/r-dbi/RMariaDB
- Add all other "native" (non-ODBC) driver to the supported test configuration (e. g. google bigquery, RODBCDBI::ODBC()):
  https://github.com/r-dbi
  https://github.com/agstudy/rsqlserver
- How about other NoSQL databases?
  https://www.r-bloggers.com/database-interfaces/
- Use R in a container to run the conformity tests for a ready-to-use stable environment?
  E. g. similar to https://github.com/ruaridhw/dockerfiles/tree/master/rsqlserver/rstudio
- rename project into "compliance" or "maturity"
- Could a docker-enabled CI service support automatic updates of the reports?
  https://yutani.rbind.io/post/2017-10-18-circleci/
- Find a way to stop long running or blocking tests after a defined grace period
  (e. g. caused by dead-locks or implementation problems with transactions)
- Test runs on different client-side platforms and with different odbc drivers
  must be considered, e. g.
    + for a unique file name for results
    + showing the odbc driver from the connection string - or the whole connection string without credentials
    + in the comparative report by giving each test configuration a unique name
- translation of internal database version numbers into "public" versions (e. g. postgresql 100001 = version 10.x)
    - SELECT current_setting('server_version_num')
    - https://wiki.postgresql.org/wiki/New_in_postgres_10#Change_in_Version_Numbering
    - As of Version 10, PostgreSQL no longer uses three-part version numbers, but is shifting to two-part version numbers.
      A six-digit integer version number which will be consistently sortable and comparable between versions 9.6 and 10
- Normale DBMS names (column "DB.name") for consistent grouping per DBMS in comparative reports
- replace data.table column indices with column names in the single test config report
- consider most popular databases (MongoDB, Redis:
  https://insights.stackoverflow.com/survey/2018/#technology-databases
  https://insights.stackoverflow.com/survey/2018/#technology-most-loved-dreaded-and-wanted-databases
  

  
  



## Done

+ improve aggregation: count number of rows (= test_that test cases) instead of "nb" column (= number of expectations)?
+ log version numbers of R, odbc and DBItest
+ store results as Excel files too (e. g. using the package `openxlsx` or `writexl` to avoid the java dependency of `xlsx`)
+ Use LibreCalc or Excel file format to maintain the test configurations (R code is not really pretty)
