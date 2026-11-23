# syntax=docker/dockerfile:1

# Étape 1 : dépendances PHP
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction
COPY . .
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

# Étape 2 : assets front-end
FROM node:24-alpine AS assets
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Étape 3 : image PHP-FPM de production (cible "php")
FROM php:8.5-fpm-alpine AS php
WORKDIR /var/www/html
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_mysql intl \
 && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker/php/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY . .
COPY --from=vendor /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build
RUN addgroup -g 1000 app && adduser -G app -u 1000 -D app \
 && mkdir -p var && chown -R app:app var
USER app
CMD ["php-fpm"]

# Étape 4 : image Nginx avec les fichiers publics (cible "web")
FROM nginx:1.28-alpine AS web
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=php /var/www/html/public /var/www/html/public
