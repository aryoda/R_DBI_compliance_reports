#!/bin/bash


docker container stop DBImysql
docker container kill DBImysql
docker container rm DBImysql



# show the remaining running containers
docker container ls -a


