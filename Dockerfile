# docker-compose build
FROM php:8.0-fpm-alpine

ENV PHPREDIS_VERSION 5.3.3
ENV FEWOHBEE_VERSION latest

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts 
    
RUN apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
		libpng-dev \
        libxml2-dev \
        icu-dev \
        pcre-dev \
        autoconf \
        git \
        zip \
        unzip \
        tzdata \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl pdo_mysql xml opcache redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]
