
#' builds a new row to configure a test run and adds it to an existing configuration
#'
#' @param test.config.table       data.table with the existing configuration (or NULL to start a new one)
#' @param test.config.name
#' @param DBI.driver.pkg.name     package name of the DBI driver as character. Will be loaded via \code{library}
#' @param DBI.driver.constructor  fully qualified function name to instantiate the driver (e. g. \code{odbc::odbc()}
#' @param con.args                connection string (or list converted into a string)
#' @param docker.start.script     optionally: the script name to start the database docker container.
#'                                Empty string means the database is aready running
#' @param docker.stop.script      optionally: the script name to stop the database docker container
#'                                Empty string means the database is not running in docker container
#'                                (or there is no need to stop it, e. g. to run another test)
#'
#' @return                        a data.table with the new config row added at the end
#'
add.test.config.row <- function(test.config.table,
                                test.config.name,
                                DBI.driver.pkg.name,
                                DBI.driver.constructor,
                                con.args,
                                docker.start.script = "",
                                docker.stop.script = ""
) {

  test.config.row <- data.table(
    test.config.name       = test.config.name,
    DBI.driver.pkg.name    = DBI.driver.pkg.name,
    DBI.driver.constructor = DBI.driver.constructor,
    con.args               = con.args,
    docker.start.script    = docker.start.script,
    docker.stop.script     = docker.stop.script
  )



  if (is.null(test.config.table))
    return(test.config.row)
  else
    return(rbindlist(list(test.config.table, test.config.row)))

}
