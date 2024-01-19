#!/bin/bash

#启动docker

docker run -d -v /tmp/ubuntu-base-`date +'%Y%m%d%H%M%S'`:/home/jovyan/logs -p 9055:9055 -t lansheng228/ubuntu-base:latest
