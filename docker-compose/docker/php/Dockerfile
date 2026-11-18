ARG PHP_VERSION=8.5

# --- Cible FPM ---
FROM php:${PHP_VERSION}-fpm AS fpm

# Certificats racine d'entreprise (proxy TLS) : voir docker/certs/README.md
COPY docker/certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/* \
    && install-php-extensions intl pdo_mysql mysqli zip gd ldap opcache bcmath xsl apcu

COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-app.ini

WORKDIR /var/www/html

# --- Cible CLI (avec Composer) ---
FROM php:${PHP_VERSION}-cli AS cli

# Certificats racine d'entreprise (proxy TLS) : voir docker/certs/README.md
COPY docker/certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/* \
    && install-php-extensions intl pdo_mysql mysqli zip gd ldap opcache bcmath xsl apcu

COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-app.ini
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Le cache doit appartenir à www-data pour que le volume composer_cache soit inscriptible
RUN mkdir -p /tmp/composer/cache && chown -R www-data:www-data /tmp/composer

ENV COMPOSER_HOME=/tmp/composer
WORKDIR /var/www/html

# --- Cible PROD : code copié dans l'image (aucun bind mount). Le contexte nommé "src" (racine du projet) est fourni par docker-compose.prod.linux.yml ---
FROM fpm AS prod
COPY --from=src --chown=www-data:www-data . /var/www/html
RUN mkdir -p var/cache var/log && chown -R www-data:www-data var
