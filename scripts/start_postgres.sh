#!/bin/bash




# user = postgres
# postgres standard IP port = 5432
docker run --name dbipostgres -e POSTGRES_PASSWORD=dbitesting -p 30000:5432 -d postgres



# Show running container
docker container ls -a

