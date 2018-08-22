FROM php:7.1.3-fpm

RUN docker-php-ext-install pdo_mysql
RUN apt-get update && apt-get install zlib1g-dev -y \
        libmcrypt-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        xvfb libfontconfig wkhtmltopdf \
	git zip \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /var/www/html
ADD composer.json .
ADD composer.lock .
ADD database database
RUN chmod -R 777 .
ADD custom.ini /usr/local/etc/php/conf.d/custom.ini
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN composer update --no-scripts  
ADD . .
RUN chmod -R 777 storage
RUN chmod -R 777 bootstrap/cache

