FROM nginx:alpine

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Code copié depuis php-fpm (même chemin dans les deux images) ; le PHP est exécuté par php-fpm
COPY --from=app /var/www/html /var/www/html
