# #!/bin/sh

# # Interface vers le switch (transport)
# ip addr add 10.1.1.1/30 dev eth0
# ip link set eth0 up

# # Création de l'interface VXLAN (VNI=10)
# # On pointe statiquement vers l'IP du VTEP distant (routeur-2)
# ip link add vxlan10 type vxlan \
#     id 10 \
#     remote 10.1.1.2 \
#     dstport 4789 \
#     dev eth0
# ip link set vxlan10 up

# # Création du bridge br0
# ip link add br0 type bridge
# ip link set br0 up

# # On attache vxlan10 et eth1 (vers le host) au bridge
# ip link set vxlan10 master br0
# ip link set eth1 master br0

# # IP du bridge (réseau overlay, vu par le host)
# ip addr add 30.1.1.1/24 dev br0

/bin/sh -c "/usr/lib/frr/docker-start & sleep 2 && ip addr add 10.1.1.1/30 dev eth0 && ip link set eth0 up && ip link add vxlan10 type vxlan id 10 remote 10.1.1.2 dstport 4789 dev eth0 && ip link set vxlan10 up && ip link add br0 type bridge && ip link set br0 up && ip link set vxlan10 master br0 && ip link set eth1 master br0 && ip addr add 30.1.1.1/24 dev br0 && while true; do sleep 1000; done"