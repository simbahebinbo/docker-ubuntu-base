#!/bin/bash

# 进入镜像内部调试

docker exec -it $(docker ps -qa --filter ancestor=ubuntu-example) /bin/bash
