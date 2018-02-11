#!/bin/bash

# https://hub.docker.com/_/mysql/



# user = root
# $ docker run -it --rm mysql mysql -hlocalhost -P3306 -uroot
# To connect from outside:
# mysql --protocol=tcp -hlocalhost -P30001 -uroot -pdbitesting
# https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-configuration-connection-parameters.html
docker run --name DBImysql -e MYSQL_ROOT_PASSWORD=dbitesting -e MYSQL_DATABASE=testdb -p 30001:3306 -d mysql



# Show running container
docker container ls -a

