# #!/bin/sh

# # === Interfaces de transport (underlay) ===
# # Adresses IP utilisées pour joindre les différents VTEP
# ip addr add 10.1.1.1/30 dev eth0
# ip addr add 10.1.1.5/30 dev eth1
# ip addr add 10.1.1.9/30 dev eth2

# ip link set eth0 up
# ip link set eth1 up
# ip link set eth2 up

# # === Adresse loopback du routeur ===
# # Cette adresse identifie de manière unique le routeur dans le réseau
# ip addr add 1.1.1.1/32 dev lo
# ip link set lo up

/bin/sh -c "/usr/lib/frr/docker-start & sleep 2 && ip addr add 10.1.1.1/30 dev eth0 && ip addr add 10.1.1.5/30 dev eth1 && ip addr add 10.1.1.9/30 dev eth2 && ip addr add 1.1.1.1/32 dev lo && ip link set eth0 up && ip link set eth1 up && ip link set eth2 up && while true; do sleep 1000; done"