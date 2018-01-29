#!/bin/bash



# Public repository:
# Official images for Microsoft SQL Server on Linux for Docker Engine.
# https://hub.docker.com/r/microsoft/mssql-server-linux/
# docker pull microsoft/mssql-server-linux

# Public repository:
# Official images for Microsoft SQL Server Command Line Tools (sqlcmd/bcp) on Linux 
# https://hub.docker.com/r/microsoft/mssql-tools/
# docker pull microsoft/mssql-tools
# Run the image in interactive mode
# docker run -it microsoft/mssql-tools



# Official repository:
# The PostgreSQL object-relational database system provides reliability and data integrity.
# https://hub.docker.com/_/postgres/
docker pull postgres



# Official repository:
# MySQL is a widely used, open-source relational database management system (RDBMS).
# https://hub.docker.com/_/mysql/
docker pull mysql



# Show all installed images
docker images ls -a


