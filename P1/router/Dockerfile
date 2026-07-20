FROM frrouting/frr:v8.4.0

RUN apk update && apk add --no-cache \
    busybox-extras \
    iproute2 \
    iputils \
    bridge-utils

# Activating the services by modifiyng etc/frr/daemons file
RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons && \
    sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons && \
    sed -i 's/isisd=no/isisd=yes/' /etc/frr/daemons

CMD ["/sbin/tini", "--", "/usr/lib/frr/docker-start"]