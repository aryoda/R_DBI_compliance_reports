# Load and prepare the test configurations
get.test.configurations <- function(test.config.file.name = "test_configs.xlsx") {

  res <- openxlsx::read.xlsx(test.config.file.name, sheet = "test_configs", colNames = TRUE)

  setDT(res)



  # Convert test execution marker column into logical (fault tolerant)
  res[, execute.test := toupper(stri_trim_both(execute.test))]
  res[, execute.test.flag := ifelse(execute.test %in% (c("X", "TRUE", "YES")), TRUE, FALSE)]

  return(res)

}
