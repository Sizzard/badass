# # !/bin/sh

# # Le host a juste besoin d'une IP dans le réseau overlay
# ip addr add 30.1.1.2/24 dev eth1  # pour host-2
# ip link set eth1 up

/bin/sh -c "ip addr add 30.1.1.2/24 dev eth1 && ip link set eth1 up && while true; do sleep 1000; done"