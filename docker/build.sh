#!/bin/sh

docker build -t xiusin/php-fpm-phalcon-7.4.28 .

# 清除 <none> 标签的镜像
docker image prune -f