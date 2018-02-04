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
- List known DBI driver packages in the readme (reverse dependency of CRAN may help but it ignores new packages at github...)
- store results as CSV file to be read again for comparing the results of different set-ups
- also check odbc:RODBC bridge driver to show differences in implementations (RODBCDBI::ODBC())
- call test_all + specify the skip param instead of calling every single test case group (for a correct skip summary)
- fix or minimize transaction testing problem (e. g. via skip until the bug is fixed in `odbc`)
- centralize used color scheme (color codes) to support changing it in one place (currently spreaded in the report)
- rename testhat reporter column names in result.raw for consistent names in reports (no more renamings in reports)
- result.raw: logical columns should be converted to Y/N (nicer in reports than true/false)




## Done

+ improve aggregation: count number of rows (= test_that test cases) instead of "nb" column (= number of expectations)?
+ log version numbers of R, odbc and DBItest
+ store results as Excel files too (e. g. using the package `openxlsx` or `writexl` to avoid the java dependency of `xlsx`)
