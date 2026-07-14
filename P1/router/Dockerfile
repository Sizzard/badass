# Image 2 : routeur avec FRR
FROM frrouting/frr:latest

RUN apk update && apk add --no-cache \
    busybox-extras \
    iproute2 \
    iputils

# Activer les services nécessaires
RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons && \
    sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons && \
    sed -i 's/isisd=no/isisd=yes/' /etc/frr/daemons && \
    sed -i 's/zebra=no/zebra=yes/' /etc/frr/daemons

CMD ["/sbin/tini", "--", "/usr/lib/frr/docker-start"]