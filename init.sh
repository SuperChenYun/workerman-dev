#!/bin/bash

if [ ! -e /app/start.php ];then
    echo "Init Workerman "
    cd /app && /usr/bin/composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && composer require workerman/workerman
    cp /start.php /app/start.php
    cd /app && chown -R root /app
fi
