FROM httpd:2.4

RUN sed -i \
        -e 's|^#\(LoadModule proxy_module .*\)|\1|' \
        -e 's|^#\(LoadModule proxy_fcgi_module .*\)|\1|' \
        -e 's|^#\(LoadModule rewrite_module .*\)|\1|' \
        -e 's|^#\(LoadModule headers_module .*\)|\1|' \
        -e 's|^#\(LoadModule deflate_module .*\)|\1|' \
        -e 's|^#\(Include conf/extra/httpd-vhosts.conf\)|\1|' \
        /usr/local/apache2/conf/httpd.conf

COPY apache/vhost.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
