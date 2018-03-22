normalize.DBMS.names <- function(DBMS.names, DBMS.version) {

  stopifnot(length(DBMS.names) == length(DBMS.version))



  # fix known "non-pretty" DBMS names (as produced by driver packages)
  DBMS.names[DBMS.names == "postgres"] <- "PostgreSQL"



  # Microsoft SQL Server:
  # Dervice the version number ("year") from the build number
  # https://buildnumbers.wordpress.com/sqlserver/
  major.build.number <- as.character(substr(DBMS.version, 1, 3))
  is.mssql <- toupper(DBMS.names) == toupper("Microsoft SQL Server")

  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "14.")] <- "Microsoft SQL Server 2017"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "13.")] <- "Microsoft SQL Server 2016"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "12.")] <- "Microsoft SQL Server 2014"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "11.")] <- "Microsoft SQL Server 2012"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "10.")] <- "Microsoft SQL Server 2008"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "9.0")] <- "Microsoft SQL Server 2005"
  DBMS.names[is.mssql & stri_startswith_fixed(DBMS.version, "8.0")] <- "Microsoft SQL Server 2000"



  return(DBMS.names)

}
