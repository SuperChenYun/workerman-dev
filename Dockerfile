FROM centos:latest

LABEL maintainer="The Easyswoole Dev <itzcy@itzcy.com>"

WORKDIR /app
# 安装常用软件
RUN yum install -y curl wget zip zlib openssl make openssl-devel gcc glibc-headers gcc-c++ libxml2 libxml2-devel libzip libzip-devel libevent-devel \
 && yum clean all

# 安装PHP7.3.12 配置PHP7.3.12
RUN wget -O /app/php-7.3.12.tar.gz https://www.php.net/distributions/php-7.3.12.tar.gz \
 && tar zxvf php-7.3.12.tar.gz \
 && cd php-7.3.12 \
 && ./configure --prefix=/usr/local/php \ 
   --with-config-file-path=/usr/local/php/etc \
   --enable-bcmath \
   --enable-mbstring \
   --with-openssl \
   --with-xmlrpc \
   --with-mysqli \
   --with-pdo-mysql \
   --enable-zip \
   -enable-pcntl \
   --without-pear \
 && make -j4 \
 && make install \
 && mkdir /usr/local/php/etc/ \
 && cp ./php.ini-development /usr/local/php/etc/php.ini \ 
 && ln -s /usr/local/php/bin/php /usr/bin/php \
 && ln -s /usr/local/php/bin/php-config /usr/bin/php-config \
 && ln -s /usr/local/php/bin/phpize /usr/bin/phpize \
 && rm -rf /app/* \
 && php -v

RUN curl -Ss http://www.workerman.net/check.php | php

# 安装composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "echo hash_file('sha384', 'composer-setup.php') . PHP_EOL;" \
 && php composer-setup.php \
 && php -r "unlink('composer-setup.php');" \
 && mv composer.phar /usr/local/php/bin/composer \
 && ln -s /usr/local/php/bin/composer /usr/bin/composer \
 && rm -rf /app/*

VOLUME ["/app"]

EXPOSE 9500

# 初始化workerman
COPY ./start.php /start.php
COPY ./init.sh /init.sh

CMD bash /init.sh && php /app/start.php start