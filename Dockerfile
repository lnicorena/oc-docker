# FROM php:7.1.2-apache 
# RUN docker-php-ext-install mysqli
FROM  php:7.1-apache

RUN apt-get update && \
    apt-get install -y -qq git \
        libjpeg62-turbo-dev \
        apt-transport-https \
        libfreetype6-dev \
        libmcrypt-dev \
        libpng12-dev \
        libssl-dev \
        zip unzip \
        nodejs \
        npm \
        wget \
        vim

RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) mysqli mcrypt zip pdo_mysql gd bcmath
# RUN docker-php-ext-install -j$(nproc) mysqli iconv mcrypt zip pdo pdo_mysql gd bcmath

# COPY ./containers/yii.conf /etc/apache2/sites-available/000-default.conf

RUN for mod in rewrite headers; do a2enmod $mod; done && service apache2 restart

WORKDIR /var/www/html/

# warning: iconv (iconv.so) is already loaded!
# mkdir: cannot create directory '.libs': File exists
# warning: pdo (pdo.so) is already loaded!