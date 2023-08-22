FROM php:7.4-fpm-alpine

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install postgres driver and intl package for php
RUN set -ex \
    && apk --no-cache add postgresql-dev \
    && docker-php-ext-install pgsql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Change uid for process user to avoid permission issues to 1000 (same as host user, normally)
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

