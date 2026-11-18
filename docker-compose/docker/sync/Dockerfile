FROM alpine:3

# The development proxy replaces Alpine's TLS certificate. APK still verifies
# package signatures, so use HTTP only for this bootstrap install and keep the
# repository configuration HTTPS afterwards.
RUN sed -i 's/^https:/http:/' /etc/apk/repositories \
    && apk add --no-cache rsync \
    && sed -i 's/^http:/https:/' /etc/apk/repositories

COPY sync/sync.sh /usr/local/bin/sync.sh
COPY sync/excludes.txt /etc/sync-excludes.txt
RUN sed -i 's/\r$//' /usr/local/bin/sync.sh /etc/sync-excludes.txt && chmod +x /usr/local/bin/sync.sh

ENTRYPOINT ["/usr/local/bin/sync.sh"]
