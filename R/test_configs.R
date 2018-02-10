# To install required odbc drivers on Ubuntu Linux 14.04:

# PostgreSQL ODBC ODBC Drivers
# sudo apt-get install odbc-postgresql

# MySQL ODBC Drivers
# apt-get install libmyodbc

# SQLite ODBC Drivers
# sudo apt-get install libsqliteodbc



# See the connection string reference for the syntax of your database:
# https://www.connectionstrings.com/
#
# Do not use square brackets in the driver name otherwise the connection will work work!

# sqlite3 (embedded database in one file with "in-memory-only" support
test.configs <- add.test.config.row(NULL, "sqlite3 with RSQLLite driver", "RSQLite", "RSQLite::SQLite()", "dbname=:memory:")
test.configs <- add.test.config.row(test.configs, "sqlite3 with odbc driver", "odbc", "odbc::odbc()", "driver=SQLite3; database=:memory:")

# Postgres v10 in a docker image
# No need to create a DSN in odbc.ini (just the driver name is required and pre-installed in odbcinst.ini)
test.configs <- add.test.config.row(test.configs, "PostgreSQL Unicode with odbc driver", "odbc", "odbc::odbc()",
                                    "driver=PostgreSQL Unicode;Database=postgres;Uid=postgres;Pwd=dbitesting;Server=localhost;Port=30000;",
                                    "start_postgres.sh", "stop_postgres.sh")

test.configs <- add.test.config.row(test.configs, "PostgreSQL with RPostgres driver", "RPostgres", "RPostgres::Postgres()",
                                    "dbname=postgres; user=postgres; password=dbitesting; host=localhost; port=30000;",
                                    "start_postgres.sh", "stop_postgres.sh")

# use 127.0.0.1 instead of "localhost" as server to switch from name Unix socket files to TCP protocol
# https://dev.mysql.com/doc/refman/5.5/en/connecting.html
test.configs <- add.test.config.row(test.configs, "mysql with odbc driver", "odbc", "odbc::odbc()",
                                    "driver = MySQL; server = 127.0.0.1; port = 30001; user = root; password=dbitesting; database = testdb; option=3; protocol = tcp;",
                                    "start_mysql.sh", "stop_mysql.sh")
test.configs <- add.test.config.row(test.configs, "mysql with RMariaDB driver", "RMariaDB", "RMariaDB::MariaDB()",
                                    "host=127.0.0.1; port=30001; username=root; password=dbitesting; database = testdb; option=3; protocol=tcp;",
                                    "start_mysql.sh", "stop_mysql.sh")
