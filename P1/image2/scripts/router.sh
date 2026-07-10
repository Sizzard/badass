#!/bin/sh

sed -i \
    -e 's/zebra=no/zebra=yes/' \
    -e 's/bgpd=no/bgpd=yes/' \
    -e 's/ospfd=no/ospfd=yes/' \
    -e 's/isisd=no/isisd=yes/' \
    /etc/frr/daemons

/usr/lib/frr/frrinit.sh start

exec telnetd -F -l /bin/sh -p 5000