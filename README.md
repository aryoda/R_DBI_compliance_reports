# DBI conformity reports for database access with R

This repository is intended as a collection of reports that compare how much different databases support DBI-based data access using the [programming language R][1].

The DBI conformity is checked by applying the unit tests of the package [`DBItest`][3].

**For a first example of a result report see this [real-life report](https://htmlpreview.github.io/?https://github.com/aryoda/R_DBI_DB_conformity_reports/blob/master/results/examples/example_result_report.html)
and [the correspondig raw data](results/examples/example_result_raw_data.xlsx) (still based on postgreSQL).**



## `DBI` is...

*"... a common interface between R/S and RDBMS that would allow users to access data stored on database servers in a uniform and predictable manner irrespective of the database engine. The interface defines a small set of classes and methods similar in spirit to Python’s DB-API, Java’s JDBC, Microsoft’s ODBC, Perl’s DBI, etc."*

Source: https://cran.r-project.org/web/packages/DBI/vignettes/DBI-proposal.html

Just remember: DBI = (a common) Database interface



## Use cases of the reports

1. Decide if a DBI driver covers the requirements of a project for a specific database
1. Compare the working features of different drivers for the same database (e. g. `odbc` vs. `RPostgreSQL` packages)
1. Help developers of DBI drivers to find gaps and improve their drivers toward full DBI-conformity
1. Help database vendors (their developers) to close gaps in the database engines required to be DBI-conform
   (e. g. for new big-data or noSQL databases)



## Current status

Currently the first goal is the check the Microsoft SQL Server 2017 using the DBI-ODBC "bridge"
provided by the [`odbc`][2] package.

The work is still in progress based on postgreSQL on Linux (see [TODO list](TODO.md))...

Last status update: Jan 28, 2018



## I have a dream...

... to provide **a central DBI-conformity database** that

1. is showing the DBI-conformity status of all database/DBI-driver/client-OS combinations
1. is updated whenever a new version of a database is released
1. is updated whenever a new version of DBI-driver is published (e. g. via *continuous integration* with [docker][4])
1. is finally showing 100 % DBI-conformity for all database/DBI-driver/client-OS combinations ;-)

OK, to be realistic: I can't do this alone - so please contribute if you want the dream to become true!



## References

1. [Programming language R](https://www.r-project.org/)
1. [DBI package for R: Declares the formal DBI interface](https://github.com/r-dbi/DBI)
1. [DBItest package for R: Contains unit tests to check DBI conformity](https://github.com/r-dbi/DBItest)
1. [odbc package for R: DBI-based driver to use the ODBC interface for database access](https://github.com/r-dbi/odbc)
1. [Docker containerization platform](https://www.docker.com/)
1. [Connection string syntax and examples for many database vendors](https://www.connectionstrings.com)
1. [R driver packages that implement the DBI interface (see *Reverse depends*)](https://cran.r-project.org/web/packages/DBI/index.html)



[1]: https://www.r-project.org/
[2]: https://github.com/r-dbi/odbc
[3]: https://github.com/r-dbi/DBItest
[4]: https://www.docker.com/


