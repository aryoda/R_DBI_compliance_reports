# one row over all test results
summarize.all.test <- function(results) {

  res <- results[, .(
    success.rate = round((1 - ((sum(skipped) + sum(failed)) / sum(nb))) * 100, 1), # unclear: also consider error count?
    num.of.tests = sum(nb),
    failed   = sum(failed),
    errors   = sum(error),
    warnings = sum(warning),
    skipped  = sum(skipped)
  ),
  by = .(DB.name, DB.version)]

  return(res)

}



# One aggregated row per test group
summarize.test.per.group <- function(results) {

  # Summarize the test results
  res <- results[, .(
                   success.rate = round((1 - ((sum(skipped) + sum(failed)) / sum(nb))) * 100, 1), # unclear: also consider error count?
                   num.of.tests = sum(nb),
                   failed   = sum(failed),
                   errors   = sum(error),
                   warnings = sum(warning),
                   skipped  = sum(skipped)
                   ),
                by = .(DB.name, DB.version, test.group)]

  return(res)



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


  #       DB.name DB.version      test_group num.of.tests success.rate failed errors warnings skipped
  # 1: PostgreSQL       10.1 Getting started           11         90.9      1      0        0       0
  # 2: PostgreSQL       10.1          Driver          104        100.0      0      0        0       0
  # 3: PostgreSQL       10.1      Connection           89        100.0      0      0        0       0
  # 4: PostgreSQL       10.1          Result          779         97.0     23      4        0       0
  # 5: PostgreSQL       10.1             SQL         1372         98.1     26     16        0       0
  # 6: PostgreSQL       10.1        Metadata          186         84.4      4      1        0      25
  # 7: PostgreSQL       10.1 Full compliance          109        100.0      0      0        0       0

}
