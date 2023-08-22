FROM php:7.4-fpm-alpine

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install php extensions needed for wordpress
RUN set -ex \
    && apk --no-cache add \
    $PHPIZE_DEPS \
    icu-dev \
    libzip-dev \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    imagemagick \
    imagemagick-libs \
    imagemagick-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install mysqli intl exif zip gd

# Install imagemagick
RUN printf "\n" | pecl install \
    imagick && \
    docker-php-ext-enable --ini-name 20-imagick.ini imagick

# Change uid for process user to avoid permission issues to 1000 (same as host user, normally)
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
