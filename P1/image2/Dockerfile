FROM alpine:3.24

RUN apk add --no-cache \
    frr \
    busybox-extras

COPY scripts/router.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]