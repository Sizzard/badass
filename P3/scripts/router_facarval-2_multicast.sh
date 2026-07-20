# #!/bin/sh

# # === Interface vers le switch (transport) ===
# ip addr add 10.1.1.2/30 dev eth0
# ip link set eth0 up

# # === Création de l'interface VXLAN ===
# # Remote pointe vers routeur-1 cette fois
# ip link add vxlan10 type vxlan \
#     id 10 \
#     group 239.1.1.1 \
#     dstport 4789 \
#     dev eth0
# ip link set vxlan10 up

# # === Bridge br0 ===
# ip link add br0 type bridge
# ip link set br0 up

# ip link set vxlan10 master br0
# ip link set eth1 master br0

# ip addr add 30.1.1.2/24 dev br0

/bin/sh -c "/usr/lib/frr/docker-start & sleep 2 && ip addr add 10.1.1.2/30 dev eth0 && ip link set eth0 up && ip link add vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789 && ip link set vxlan10 up && ip link add br0 type bridge && ip link set br0 up && ip link set vxlan10 master br0 && ip link set eth1 master br0 && ip addr add 30.1.1.2/24 dev br0 && while true; do sleep 1000; done"