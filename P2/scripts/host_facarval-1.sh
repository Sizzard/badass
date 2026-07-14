# #!/bin/sh

# # Le host a juste besoin d'une IP dans le réseau overlay
# ip addr add 30.1.1.10/24 dev eth0    # pour host-1
# ip link set eth0 up

/bin/sh -c "ip addr add 30.1.1.10/24 dev eth0 && ip link set eth0 up && while true; do sleep 1000; done"