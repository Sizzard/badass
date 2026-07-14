FROM alpine:latest

RUN apk update && apk add --no-cache \
    busybox-extras \
    iproute2 \
    iputils

CMD ["sh", "-c", "while true; do sleep 1000; done"]