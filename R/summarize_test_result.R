# one row over all test results
summarize.all.testcase.count.based <- function(results) {

  res <- results[, .(
    test.cases      = .N,
    checked.asserts = sum(nb),
    failed.asserts  = sum(failed),
    skipped.asserts = sum(skipped),
    errors          = sum(error),
    warnings        = sum(warning)
  )
  , by = .(TC.result)  # no need to group since we are using only one DB here
  ]

  # Share of each result status at the total result
  res[, ':='(total.TC.share               = round(test.cases * 100 / sum(test.cases), 2),
             total.checked.asserts.share  = round(checked.asserts * 100 / sum(checked.asserts), 2))
        # , by = .(DB.name, DB.version)    # no need to group since we are using only one DB here
      ]




  setcolorder(res, c(# "DB.name",
                     # "DB.version",
                     "TC.result",
                     "total.TC.share",
                     "test.cases",
                     "checked.asserts",
                     "total.checked.asserts.share",
                     "failed.asserts",
                     "skipped.asserts",
                     "errors",
                     "warnings"
                     )
              )


    return(res)

}



summarize.per.group.testcase.count.based <- function(results) {

  res <- results[, .(
    TC.success.rate          = round(NROW(.SD[TC.result == "Passed",]) * 100 / .N, 2),
    test.cases               = .N,
    passed.TCs               = NROW(.SD[TC.result == "Passed",]),
    failed.TCs               = NROW(.SD[TC.result == "Failed",]),
    skipped.TCs              = NROW(.SD[TC.result == "Skipped",]),
#    test.cases.unkown.result = NROW(.SD[TC.result == "Unknown",]),  # should never happen so don't show it
    checked.asserts          = sum(nb),
    failed.asserts           = sum(failed),
    skipped.asserts          = sum(skipped),
    errors                   = sum(error),
    warnings                 = sum(warning)
  )
  , by = .(test.group)       # no need to group since we are using only one DB here
  ]



  return(res)

}



# one row over all test results
summarize.all.assert.count.based <- function(results) {

  res <- results[, .(
    asserts.success.rate   = round((1 - ((sum(skipped) + sum(failed)) / sum(nb))) * 100, 1), # TODO How to consider error count best?
    checked.asserts = sum(nb),
    failed.asserts  = sum(failed),
    skipped.asserts = sum(skipped),
    errors   = sum(error),
    warnings = sum(warning)
  )
  # , by = .(DB.name, DB.version)  # no need to group since we are using only one DB here
  ]

  return(res)

}



# One aggregated row per test group
summarize.per.group.assert.count.based <- function(results) {

  # Summarize the test results
  res <- results[, .(
    asserts.success.rate = round((1 - ((sum(skipped) + sum(failed)) / sum(nb))) * 100, 1), # unclear: also consider error count?
    checked.asserts = sum(nb),
    failed.asserts  = sum(failed),
    skipped.asserts = sum(skipped),
    errors          = sum(error),
    warnings        = sum(warning)
  ),
  by = .(test.group)]  # no need to group since we are using only one DB here

  return(res)

}


