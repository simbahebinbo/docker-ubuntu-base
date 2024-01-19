#!/bin/bash

#停掉所有正在运行的docker容器

docker ps -a
docker stop ubuntu-example
docker rm ubuntu-example
