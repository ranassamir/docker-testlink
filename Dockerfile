# 
# Dockerfile for testlink
# 
FROM php:7-apache
MAINTAINER Ranassamir Lobo <ranassamir@gmail.com> 
RUN a2enmod rewrite
RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libxml2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring mysqli pdo pdo_mysql pdo_pgsql soap \
    && rm -rf /var/lib/apt/lists/*
ENV TESTLINK_VER 1.9.16 
ENV TESTLINK_MD5 b37ab5fa125e919d86734d349ad87c51 
ENV TESTLINK_URL https://ufpr.dl.sourceforge.net/project/testlink/TestLink%201.9/TestLink%20${TESTLINK_VER}/testlink-${TESTLINK_VER}.tar.gz
ENV TESTLINK_FILE testlink.tar.gz 
RUN set -xe \
    && curl -fSL ${TESTLINK_URL} -o ${TESTLINK_FILE} \
    && echo "${TESTLINK_MD5}  ${TESTLINK_FILE}" | md5sum -c \
    && tar -xz --strip-components=2 -f ${TESTLINK_FILE} \
    && rm ${TESTLINK_FILE} \
    && chown -R www-data:www-data . \
    && mkdir -p /var/testlink/logs/ && chmod 0777 /var/testlink/logs/ \
    && mkdir -p /var/testlink/upload_area/ && chmod 0777 /var/testlink/upload_area/
RUN set -xe \
    && ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime \
    && echo 'date.timezone = "America/Bahia"' > /usr/local/etc/php/php.ini