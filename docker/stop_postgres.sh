#!/bin/bash


docker container stop dbipostgres
docker container kill dbipostgres
docker container rm dbipostgres



# show the remaining running containers
docker container ls -a


