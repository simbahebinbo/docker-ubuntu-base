#!/bin/bash

#启动docker

docker run -d -v /tmp/ubuntu-example-`date +'%Y%m%d%H%M%S'`:/home/jovyan/logs -p 9055:9055 -t ubuntu-example:latest
