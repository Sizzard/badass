FROM alpine:3.24.1

RUN apk update && apk upgrade -y && apk add --no-cache \
    busybox-extras \
    iproute2 \
    iputils

CMD ["sh", "-c", "while true; do sleep 1000; done"]