#!/bin/bash

#停掉正在运行的docker容器


docker stop $(docker ps -qa --filter ancestor=ubuntu-example)
docker rm $(docker ps -qa --filter ancestor=ubuntu-example)
docker ps -a
