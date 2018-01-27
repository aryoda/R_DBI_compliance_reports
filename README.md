# DBI conformity reports for database access with R

This repository is intended as a collection of reports that compare how much different databases support DBI-based data access using the [programming language R][1].

The DBI conformity is checked by applying the unit tests of the package [`DBItest`][3].



## Use cases of the reports

1. Decide if a DBI driver covers the requirements of a project for a specific database
1. Help developer of DBI drivers for R to improve their drivers toward full DBI-conformity
1. Help database vendors (their developers) to close gaps required to be DBI-conform (e. g. for new big-data or nosql databases)



## Current status

Currently the first goal is the check the Microsoft SQL Server 2017 using the DBI-ODBC "bridge"
provided by the [`odbc`][2] package.

The work is still in progress (see [TODO list](TODO.md))...

Last status update: Jan 27, 2018


## I have a dream...

... to provide **a central DBI-conformity database** that

1. is showing the DBI-conformity status of all database/DBI-driver combinations
1. is updated whenever a new version of a database is released
1. is updated whenever a new version of DBI-driver is published (e. g. via *continuous integration* with [docker][4])
1. shows 100 % DBI-conformity for all database/DBI-driver combinations ;-)

OK, to be realistic: I can't do this alone - so please contribute if you want the dream to become true!



## References

1. [Programming language R](https://www.r-project.org/)
1. [DBI package for R: Declares the formal DBI interface](https://github.com/r-dbi/DBI)
1. [DBItest package for R: Contains unit tests to check DBI conformity](https://github.com/r-dbi/DBItest)
1. [odbc package for R: DBI-based driver to use the ODBC interface for database access](https://github.com/r-dbi/odbc)
1. [Docker containerization platform](https://www.docker.com/)
1. [Connection string syntax and examples for many database vendors](https://www.connectionstrings.com)



[1]: https://www.r-project.org/
[2]: https://github.com/r-dbi/odbc
[3]: https://github.com/r-dbi/DBItest
[4]: https://www.docker.com/


