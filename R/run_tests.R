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



# inject connection strings without exposing them to the internet
source("localmachine.config.R")

# con.args <- mysql_con_args
# con.args <- sqlite_con_args

# con.args <- postgreSQL_docker    # works
# con.args <- mysql_on_docker      # works
con.args <- sqlite3_in_memory    # works (requires RSQLite)
# con.args <- sqlite3_odbc_in_mem  # works (using odbc)


# DBI.driver <- odbc::odbc()      # postgres and mysql
DBI.driver <- RSQLite::SQLite() # sqlite3



results.raw <- run_test_set(DBI.driver, con.args)



results               <- new.env()

results$res.raw       <- results.raw
results$test.case.groups.pivot.base <- counts.per.test.case.group.as.pivot.base(results$res.raw, incl.totals = TRUE)
results$per.group.assert.result <- summarize.per.group.assert.count.based(results.raw)
results$total.assert.summary <- summarize.all.assert.count.based(results.raw)
results$total.test.case.summary <- summarize.all.testcase.count.based(results.raw)
results$per.group.test.case.summary <- summarize.per.group.testcase.count.based(results.raw)



file.name   <- make.results.file.name(results.raw, "xlsx", TRUE, "results")
sheets.data <- list(Summary = results$per.group.test.case.summary, Details = results$res.raw)
save.raw.results.as.xlsx(sheets.data, file.name)


create_results_report(results, "R/result_report.Rmd", output.folder = "results")





# Test plots ------------------------------------------------------------------------------------------------------


# To change plot order of bars, change levels in underlying factor
# ggplot(mpg, aes(reorder_size(class))) + geom_bar()
reorder_size <- function(x) {
  factor(x, levels = names(sort(table(x))))
}


data <- counts.per.test.case.group.as.pivot.base(results$res.raw, TRUE)

# # prepare plot labels in the desired order
# data[, TC.result  := factor(TC.result, levels = c("Failed", "Skipped", "Passed"))]
# data[, test.group := factor(test.group, levels = sort(unique(test.group), decreasing = TRUE))]

TC.result.colors <- eval(formals(derive.strings.HTML.color)$string.colors)   # DIRTY reuse default value of function argument

# https://stackoverflow.com/questions/10834382/ggplot2-keep-unused-levels-barplot
# https://stackoverflow.com/questions/30739602/ggplot-reorder-stacked-bar-plot-based-on-values-in-data-frame
# https://stackoverflow.com/questions/37817809/r-ggplot-stacked-bar-chart-with-counts-on-y-axis-but-percentage-as-label
# https://stackoverflow.com/questions/37817809/r-ggplot-stacked-bar-chart-with-counts-on-y-axis-but-percentage-as-label
# d <- ggplot(data, aes(test.group)) + geom_bar(position = "fill")
# d <- ggplot(data, aes(test.group)) + geom_bar(aes(fill = TC.result, weight = test.cases), position = "fill")
# d <- ggplot(data, aes(x = test.group, y = test.cases)) + geom_bar(stat = "identity", aes(fill = TC.result), position = "fill")
d <- ggplot(data, aes(x = test.group, y = TC.pct), fill = TC.result) +
  geom_bar(stat = "identity", aes(fill = TC.result), position = position_stack(), width = 0.7) +
  # % labels in the bar segments
  # geom_text(aes(x = test.group, y = TC.pct, label = TC.pct.label),
  #         position = position_stack(vjust=0.5), color = "white", fontface = "bold", size = 3.5) +
  # number of test cases as label.
  # Requires data rows in the same order as test.group factors to show the TC.pct in the correct bar!
  #   Done before by sorting the data rows...
  geom_text(stat = "identity", aes(x = test.group, y = TC.pct, label = test.cases),
            position = position_stack(vjust = 0.5), color = "white", fontface = "bold", size = 3.5) +
  # rotate x axis labels
  # theme(axis.text.x = element_text(angle = 15, )) +
  ylab("Weight in %") +
  # now axis label
  xlab("") + # xlab("Test Case Group") +
  # assign intuitive colors to stacked bars
  scale_fill_manual(values = TC.result.colors, name = "TC result") +
  coord_flip() +
  # "Number in the bars are test case counts"
  ggtitle("Test case results per test case group (weights and counts)") +
  # Show total summary and details per test case group in two plots below each other
  facet_grid( granularity ~ ., scales = "free_y", space = "free_y")
# d <- d + geom_text(aes(x = test.group, y = TC.pct, label = TC.pct.label), position = position_stack(vjust=0.5)) # % labels in the bar segments
#   d <- d + geom_text(aes(label=test.cases, y=test.cases), vjust=1.3, size=3)
# d <- d + ylab("Weight in %")
# d <- d + scale_fill_discrete(name = "TC result")
d

data[2, test.cases := 100 ]
data[3, test.cases := 100 ]

