FROM ubuntu:22.04

USER root

#静默安装
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

#换源
RUN sed -i s:/archive.ubuntu.com:/mirrors.aliyun.com:g /etc/apt/sources.list
RUN sed -i s:/ports.ubuntu.com:/mirrors.aliyun.com:g /etc/apt/sources.list
RUN sed -i s:/security.ubuntu.com:/mirrors.aliyun.com:g /etc/apt/sources.list

RUN cat /etc/apt/sources.list
RUN apt-get clean
RUN apt-get -y update --fix-missing


#更新
RUN apt-get update && apt-get install --assume-yes apt-utils

#安装程序依赖的包
RUN apt-get install -yq --no-install-recommends build-essential
RUN apt-get install -yq --no-install-recommends pkg-config


#权限
RUN apt-get install -yq --no-install-recommends sudo

#加密
RUN apt-get install -yq --no-install-recommends openssl
RUN apt-get install -yq --no-install-recommends libssl-dev
RUN apt-get install -yq --no-install-recommends ca-certificates

#编辑器
RUN apt-get install -yq --no-install-recommends vim

#网络
RUN apt-get install -yq --no-install-recommends iputils-ping
RUN apt-get install -yq --no-install-recommends net-tools
RUN apt-get install -yq --no-install-recommends iproute2

#中文支持
RUN apt-get install -yq --no-install-recommends locales

RUN apt-get install -yq --no-install-recommends tini

RUN apt-get install -yq --no-install-recommends supervisor

#升级
RUN apt-get -y upgrade

#支持中文
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && locale-gen zh_CN.UTF-8 en_US.UTF-8


# Configure environment
ENV SHELL=/bin/bash
ENV NB_USER=jovyan
ARG NB_PASSWORD=123456
ENV NB_UID=1000
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV USER_HOME=/home/${NB_USER}
ARG LOG_DIR=${USER_HOME}/logs

# Create jovyan user with UID=1000 and in the 'users' group
#用户名 jovyan  密码:123456
RUN useradd -p `openssl passwd ${NB_PASSWORD}` -m -s ${SHELL} -u ${NB_UID} -G sudo ${NB_USER}
#sudo时免密
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


USER ${NB_USER}

# Setup jovyan home directory
RUN mkdir ${USER_HOME}/.local

#刷新库文件
RUN sudo ldconfig

#进入到工作目录
WORKDIR ${USER_HOME}

#添加源码
ADD source ${USER_HOME}/
RUN sudo chmod +x ${USER_HOME}/noexit.sh && sudo chgrp ${NB_USER} ${USER_HOME}/noexit.sh && sudo chown ${NB_USER} ${USER_HOME}/noexit.sh

#添加保持运行状态的脚本，用于调试
RUN sudo chmod +x ${USER_HOME}/idle.sh && sudo chgrp ${NB_USER} ${USER_HOME}/idle.sh && sudo chown ${NB_USER} ${USER_HOME}/idle.sh


#添加守护进程配置文件
ADD example.conf /etc/supervisor/conf.d/

RUN sudo mkdir -p ${LOG_DIR} && sudo chgrp -R ${NB_USER} ${LOG_DIR} && sudo chown -R ${NB_USER} ${LOG_DIR} && sudo chmod 777 ${LOG_DIR}

#暴露卷
VOLUME ${LOG_DIR}

ENTRYPOINT exec sudo /usr/bin/supervisord --nodaemon

#保持运行状态，用于调试
#ENTRYPOINT exec /usr/bin/tini -- ${USER_HOME}/idle.sh





