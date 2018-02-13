# Converts a list containing the connection properties as key/value list into a connection string.
# Removes sensitive credentials.
build.connect.string <- function(connect.args, remove.credentials = TRUE) {

  stopifnot(is.list(connect.args))



  if (remove.credentials) {

    credential.keys <- toupper(c("UID", "USER", "USERNAME", "PWD", "PASSWORD"))

    keys <- names(connect.args)

    names(connect.args) = toupper(keys)
    connect.args[credential.keys] = NULL        # remove all sensitive data

  }



  res <- paste(names(connect.args), connect.args, sep = "=", collapse = "; ")

  return(res)
}
