# TODO list

## Open

- Create RMarkdown report for summarized and detailled results and plots (comparing all tested databases)
- Refactor code to allow reuse
- Dockerize?
- Improve `DBItest` (annotate test cases with description, functions under test, link to test code,
  annotate each checked expectation with a good name, add a severity class to each test {fatal, err, warn, info} ...)
- fix or minimize transaction testing problem (e. g. via skip until the bug is fixed in `odbc`)
- log version numbers of R, odbc and DBItest
- store historical results to show a time series of test results
- result details show per single test case:
  Passed, Failed, Skipped with green, red, yellow background + personal notes + link to open ticket(s)...
- improve aggregation: count number of rows (= test_that test cases) instead of "nb" column (= number of expectations)?
- Document know DBI driver packages (reverse dependency of CRAN but this ignores new packages at github...)
+ store results as Excel files too (e. g. using the package `openxlsx` or `writexl` to avoid the java dependency of `xlsx`)
- store results as CSV file to be read again for comparing the results of different set-ups
